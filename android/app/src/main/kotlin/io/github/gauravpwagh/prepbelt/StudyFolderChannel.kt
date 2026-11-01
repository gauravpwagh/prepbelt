package io.github.gauravpwagh.prepbelt

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.provider.DocumentsContract
import android.provider.DocumentsContract.Document
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.util.concurrent.Executors

/**
 * The study folder (D51) through the Storage Access Framework, for
 * lib/platform/files/study_folder.dart. A folder is a tree URI with a
 * persisted read and write grant; files in it are named by their path
 * inside it ("Physics/Optics.pdf"), resolved by walking display names.
 * File work runs on a background thread; results return on the main one.
 */
class StudyFolderChannel(private val activity: Activity) : MethodChannel.MethodCallHandler {
    companion object {
        const val NAME = "prepbelt/folder"
        private const val CHOOSE = 4101
        private const val PICK = 4102
    }

    private val io = Executors.newSingleThreadExecutor()
    private val main = Handler(Looper.getMainLooper())
    private val resolver get() = activity.contentResolver
    private var pending: MethodChannel.Result? = null
    private var pendingTree: Uri? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val folder = call.argument<String>("folder")?.let(Uri::parse)
        val path = call.argument<String>("path") ?: ""
        when (call.method) {
            "choose" -> choose(result)
            "pickPdf" -> pickPdf(folder!!, result)
            "available" -> background(result) { available(folder!!) }
            "label" -> background(result) { label(folder!!) }
            "exists" -> background(result) { find(folder!!, path) != null }
            "list" -> background(result) {
                list(folder!!, path, call.argument<Boolean>("recursive") ?: false)
            }
            "copyIn" -> background(result) {
                copyIn(folder!!, call.argument<String>("from")!!, call.argument<String>("name")!!)
            }
            "write" -> background(result) {
                write(folder!!, path, call.argument<ByteArray>("bytes")!!); null
            }
            "read" -> background(result) {
                find(folder!!, path)?.let { uri -> resolver.openInputStream(uri)?.use { it.readBytes() } }
            }
            "copyOut" -> background(result) {
                find(folder!!, path)?.let { cacheCopy(it, File(path).name) }
            }
            "delete" -> background(result) {
                find(folder!!, path)?.let { DocumentsContract.deleteDocument(resolver, it) } ?: false
            }
            "open" -> open(folder!!, path, result)
            "release" -> {
                runCatching {
                    resolver.releasePersistableUriPermission(
                        folder!!,
                        Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION,
                    )
                }
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    /** Delivered by MainActivity. True when the request was ours. */
    fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode != CHOOSE && requestCode != PICK) return false
        val result = pending ?: return true
        pending = null
        val uri = data?.data
        if (resultCode != Activity.RESULT_OK || uri == null) {
            result.success(null)
            return true
        }
        if (requestCode == CHOOSE) {
            val flags = Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION
            try {
                resolver.takePersistableUriPermission(uri, flags)
                result.success(uri.toString())
            } catch (e: SecurityException) {
                result.error("denied", e.message, null)
            }
        } else {
            val tree = pendingTree!!
            background(result) { picked(tree, uri) }
        }
        return true
    }

    private fun choose(result: MethodChannel.Result) {
        if (pending != null) return result.error("busy", "A picker is open", null)
        pending = result
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT_TREE).addFlags(
            Intent.FLAG_GRANT_READ_URI_PERMISSION or
                Intent.FLAG_GRANT_WRITE_URI_PERMISSION or
                Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION,
        )
        start(intent, CHOOSE)
    }

    private fun pickPdf(tree: Uri, result: MethodChannel.Result) {
        if (pending != null) return result.error("busy", "A picker is open", null)
        pending = result
        pendingTree = tree
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT)
            .addCategory(Intent.CATEGORY_OPENABLE)
            .setType("application/pdf")
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            runCatching { intent.putExtra(DocumentsContract.EXTRA_INITIAL_URI, root(tree)) }
        }
        start(intent, PICK)
    }

    private fun start(intent: Intent, code: Int) {
        try {
            activity.startActivityForResult(intent, code)
        } catch (e: ActivityNotFoundException) {
            pending?.error("unavailable", e.message, null)
            pending = null
        }
    }

    private fun picked(tree: Uri, uri: Uri): Map<String, Any?> {
        var name = "document.pdf"
        var size = 0L
        resolver.query(
            uri,
            arrayOf(Document.COLUMN_DISPLAY_NAME, Document.COLUMN_SIZE),
            null, null, null,
        )?.use { c ->
            if (c.moveToFirst()) {
                c.getString(0)?.let { name = it }
                if (!c.isNull(1)) size = c.getLong(1)
            }
        }
        return mapOf(
            "name" to name,
            "bytes" to size,
            "inFolder" to pathInTree(tree, uri),
            "localCopy" to cacheCopy(uri, name),
        )
    }

    /** The picked document's path inside the tree, or null if outside. */
    private fun pathInTree(tree: Uri, uri: Uri): String? {
        if (uri.authority != tree.authority) return null
        val rootId = DocumentsContract.getTreeDocumentId(tree)
        val docId = runCatching { DocumentsContract.getDocumentId(uri) }.getOrNull() ?: return null
        // External storage ids carry the path ("primary:Documents/PrepBelt/a.pdf").
        if (docId.startsWith("$rootId/")) return docId.substring(rootId.length + 1)
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return null
        val ids = runCatching {
            DocumentsContract.findDocumentPath(
                resolver,
                DocumentsContract.buildDocumentUriUsingTree(tree, docId),
            )?.path
        }.getOrNull() ?: return null
        if (ids.firstOrNull() != rootId) return null
        val names = mutableListOf<String>()
        for (id in ids.drop(1)) {
            names += name(DocumentsContract.buildDocumentUriUsingTree(tree, id)) ?: return null
        }
        return names.joinToString("/")
    }

    private fun root(tree: Uri): Uri =
        DocumentsContract.buildDocumentUriUsingTree(tree, DocumentsContract.getTreeDocumentId(tree))

    private fun available(tree: Uri): Boolean {
        val granted = resolver.persistedUriPermissions.any {
            it.uri == tree && it.isReadPermission && it.isWritePermission
        }
        return granted && runCatching { name(root(tree)) != null }.getOrDefault(false)
    }

    private fun label(tree: Uri): String {
        val id = DocumentsContract.getTreeDocumentId(tree)
        if (tree.authority == "com.android.externalstorage.documents" && id.contains(':')) {
            val path = id.substringAfter(':')
            if (path.isNotEmpty()) return path
        }
        return name(root(tree)) ?: id
    }

    private fun name(doc: Uri): String? =
        resolver.query(doc, arrayOf(Document.COLUMN_DISPLAY_NAME), null, null, null)?.use { c ->
            if (c.moveToFirst()) c.getString(0) else null
        }

    private data class Child(val id: String, val name: String, val mime: String, val size: Long, val modified: Long)

    private fun children(tree: Uri, parentId: String): List<Child> {
        val uri = DocumentsContract.buildChildDocumentsUriUsingTree(tree, parentId)
        val out = mutableListOf<Child>()
        resolver.query(
            uri,
            arrayOf(
                Document.COLUMN_DOCUMENT_ID,
                Document.COLUMN_DISPLAY_NAME,
                Document.COLUMN_MIME_TYPE,
                Document.COLUMN_SIZE,
                Document.COLUMN_LAST_MODIFIED,
            ),
            null, null, null,
        )?.use { c ->
            while (c.moveToNext()) {
                out += Child(
                    c.getString(0),
                    c.getString(1) ?: "",
                    c.getString(2) ?: "",
                    if (c.isNull(3)) 0 else c.getLong(3),
                    if (c.isNull(4)) 0 else c.getLong(4),
                )
            }
        }
        return out
    }

    /** The document id at [path] inside the tree ("" is the root). */
    private fun findId(tree: Uri, path: String): String? {
        var id = DocumentsContract.getTreeDocumentId(tree)
        for (part in path.split('/').filter { it.isNotEmpty() }) {
            id = children(tree, id).firstOrNull { it.name == part }?.id ?: return null
        }
        return id
    }

    private fun find(tree: Uri, path: String): Uri? =
        findId(tree, path)?.let { DocumentsContract.buildDocumentUriUsingTree(tree, it) }

    private fun list(tree: Uri, dir: String, recursive: Boolean): List<Map<String, Any?>> {
        val start = findId(tree, dir) ?: return emptyList()
        val out = mutableListOf<Map<String, Any?>>()
        fun walk(id: String, prefix: String) {
            for (c in children(tree, id)) {
                val p = if (prefix.isEmpty()) c.name else "$prefix/${c.name}"
                if (c.mime == Document.MIME_TYPE_DIR) {
                    if (recursive) walk(c.id, p)
                } else {
                    out += mapOf("path" to p, "bytes" to c.size, "modified" to c.modified)
                }
            }
        }
        walk(start, dir.trim('/'))
        return out
    }

    /** The folder at [dir], made if missing. */
    private fun ensureDir(tree: Uri, dir: String): String {
        var id = DocumentsContract.getTreeDocumentId(tree)
        for (part in dir.split('/').filter { it.isNotEmpty() }) {
            val existing = children(tree, id).firstOrNull { it.name == part }
            id = existing?.id ?: DocumentsContract.getDocumentId(
                DocumentsContract.createDocument(
                    resolver,
                    DocumentsContract.buildDocumentUriUsingTree(tree, id),
                    Document.MIME_TYPE_DIR,
                    part,
                ) ?: error("Couldn't create $part"),
            )
        }
        return id
    }

    /** Copies a local file to the folder's top level as [name], or a free
     *  variant of it. Returns its path inside the folder. */
    private fun copyIn(tree: Uri, from: String, name: String): String {
        val rootId = DocumentsContract.getTreeDocumentId(tree)
        val taken = children(tree, rootId).map { it.name }.toSet()
        val base = name.substringBeforeLast('.')
        val ext = if (name.contains('.')) "." + name.substringAfterLast('.') else ""
        var candidate = name
        var n = 2
        while (candidate in taken) candidate = "$base ($n)$ext".also { n++ }
        val doc = DocumentsContract.createDocument(
            resolver,
            DocumentsContract.buildDocumentUriUsingTree(tree, rootId),
            if (ext.equals(".pdf", true)) "application/pdf" else "application/octet-stream",
            candidate,
        ) ?: error("Couldn't create $candidate")
        try {
            File(from).inputStream().use { input ->
                resolver.openOutputStream(doc, "w")!!.use { input.copyTo(it) }
            }
        } catch (e: Exception) {
            runCatching { DocumentsContract.deleteDocument(resolver, doc) }
            throw e
        }
        return name(doc) ?: candidate
    }

    /** Writes [bytes] at [path] through a temporary file, so a failed write
     *  never replaces what is there. */
    private fun write(tree: Uri, path: String, bytes: ByteArray) {
        val dir = path.substringBeforeLast('/', "")
        val fileName = path.substringAfterLast('/')
        val dirId = ensureDir(tree, dir)
        val dirUri = DocumentsContract.buildDocumentUriUsingTree(tree, dirId)
        val tmpName = "$fileName.part"
        children(tree, dirId).firstOrNull { it.name == tmpName }?.let {
            DocumentsContract.deleteDocument(resolver, DocumentsContract.buildDocumentUriUsingTree(tree, it.id))
        }
        val tmp = DocumentsContract.createDocument(resolver, dirUri, "application/octet-stream", tmpName)
            ?: error("Couldn't create $tmpName")
        try {
            resolver.openOutputStream(tmp, "w")!!.use { it.write(bytes) }
            children(tree, dirId).firstOrNull { it.name == fileName }?.let {
                DocumentsContract.deleteDocument(resolver, DocumentsContract.buildDocumentUriUsingTree(tree, it.id))
            }
            DocumentsContract.renameDocument(resolver, tmp, fileName) ?: error("Couldn't rename $tmpName")
        } catch (e: Exception) {
            runCatching { DocumentsContract.deleteDocument(resolver, tmp) }
            throw e
        }
    }

    /** A copy in the app cache, for hashing and reading bookmarks. */
    private fun cacheCopy(uri: Uri, name: String): String {
        val dir = File(activity.cacheDir, "folder").apply { mkdirs() }
        val out = File(dir, "${System.nanoTime()}-${name.replace('/', '_')}")
        resolver.openInputStream(uri)!!.use { input -> out.outputStream().use { input.copyTo(it) } }
        return out.path
    }

    private fun open(tree: Uri, path: String, result: MethodChannel.Result) {
        io.execute {
            val uri = runCatching { find(tree, path) }.getOrNull()
            main.post {
                if (uri == null) return@post result.success(false)
                val intent = Intent(Intent.ACTION_VIEW)
                    .setDataAndType(uri, "application/pdf")
                    .addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                try {
                    activity.startActivity(intent)
                    result.success(true)
                } catch (e: ActivityNotFoundException) {
                    result.success(false)
                }
            }
        }
    }

    private fun background(result: MethodChannel.Result, work: () -> Any?) {
        io.execute {
            try {
                val value = work()
                main.post { result.success(value) }
            } catch (e: Exception) {
                main.post { result.error("io", e.message ?: e.toString(), null) }
            }
        }
    }
}
