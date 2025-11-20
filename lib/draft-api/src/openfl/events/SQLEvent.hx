package openfl.events;

/**
 * ...
 * @author Christopher Speciale
 */
class SQLEvent extends Event
{

	public static inline var ANALYZE:EventType<SQLEvent> = "analyze";
	public static inline var ATTACH:EventType<SQLEvent> = "attach";
	public static inline var BEGIN:EventType<SQLEvent> = "begin";
	public static inline var CANCEL:EventType<SQLEvent> = "cancel";
	public static inline var CLOSE:EventType<SQLEvent> = "close";
	public static inline var COMMIT:EventType<SQLEvent> = "commit";
	public static inline var COMPACT:EventType<SQLEvent> = "compact";
	public static inline var DEANALYZE:EventType<SQLEvent> = "deanalyze";
	public static inline var DETACH:EventType<SQLEvent> = "detach";
	public static inline var OPEN:EventType<SQLEvent> = "open";
	public static inline var RELEASE_SAVEPOINT:EventType<SQLEvent> = "releaseSavepoint";
	public static inline var RESULT:EventType<SQLEvent> = "result";
	public static inline var ROLLBACK:EventType<SQLEvent> = "rollback";
	public static inline var ROLLBACK_TO_SAVEPOINT:EventType<SQLEvent> = "rollbackToSavepoint";
	public static inline var SCHEMA:EventType<SQLEvent> = "schema";
	public static inline var SET_SAVEPOINT:EventType<SQLEvent> = "cancel";
	
	public function new(type:EventType<SQLEvent>) 
	{
		super(type);
	}
	
}