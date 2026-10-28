/// Enumerated column values. Stored as their [Enum.name] text, so renaming
/// a value is a migration.
library;

enum SourceType { pdf, book, video, link, notes, qbank }

enum UnitType { page, minute, question, item }

enum TaskKind { learn, practice }

enum TaskStatus { active, paused, archived }

enum ReviewKind { firstRead, review, quiz }

enum LineageOp { split, merge, expand }

enum CardType { flash, mcq }

enum ExamStatus { upcoming, done, archived }

enum Importance { high, medium, low }

enum PlanItemKind { firstRead, review, finalReview, explore }

enum ReadingStatus { open, saved, discarded }

enum PlanItemStatus { planned, done, skipped, moved }

enum TemplateKind { syllabus, sourceList, examPack }

enum TemplateOrigin { local, imported }

enum EventOp { create, update, delete, split, merge, review }
