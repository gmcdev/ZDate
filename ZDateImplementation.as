﻿package {		import flash.display.Sprite;	import com.ff0000.utils.zdate.ZDate;	public class ZDateImplementation extends Sprite {		public function ZDateImplementation() {						// --- Create ZDate object			var zDate:ZDate = new ZDate();									// --- set verbosity: 0 = no trace, 1 = all trace			zDate.verbosity = 0;									// --- find out client's time in UTC			trace( 'client UTC time: ' + zDate.getClientsTimeInUTC());									// --- find out client's GMT-Offset			trace( 'client GMT offset: ' + zDate.getFormattedClientGmtOffset());									// --- incoming textual representations of time -----------------------------------------------------			//		Several examples below, many more are supported, many more can be written, contact Greg2.0			//		Current forms are all built off the GNU DateTime spec, found here:			//		http://www.gnu.org/software/automake/manual/tar/Date-input-formats.html#SEC119			//			//var test:String = 'Mon 20 aug 10 5:59:00-0700';			//var test:String = '20 aug 10 10:15 AM';			//var test:String = 'Wednesday, September 8th, 2011, 10:30am';			//var test:String = 'Sat, 24 Sep 2011 19:15:00 PDT';			//var test:String = '2011-10-14T20:00';			var test:Date = new Date();									// --- parse textual time ---------------------------------------------------------------------------			//		makeTimeFrom( $_textualDateTime:String, $_correctForDst:Boolean = false )			//			//		make time from Flash-Date, Date-String, or Unix Timestamp			//		 - if your date has no clear DST indication, use $_correctForDst - it will assume the client's GMT-Offset/DST			//		 - if you want to make sure a date is accurate in a specific GMT-offset, even during DST,			//			write your date string with in GMT-Offset of your target timezone *without* DST,			//			then set $_correctForDst = true...so for example:			//				you want your time to be 5pm EST, even during DST 	->	use '5pm GMT-0500', $_correctForDst = true;			//zDate.makeTimeFrom( test+' GMT-0500', true );			zDate.makeTimeFrom( test, true );									// --- change the timezone to a different GMT-Offset 			zDate.changeTimezoneTo( zDate.getFormattedClientGmtOffset());									// --- Use most of the codes from this table to format a date: http://us2.php.net/manual/en/function.date.php			var formatted:String = zDate.format( 'l F jS H:i:s O Y' );			trace( formatted );						// --- Use '\\text\\' to escape strings in the zDate.format method			var escapedFormatted:String = zDate.format( '\\There are \\t\\ days in the month of \\F.' );			trace( escapedFormatted );						// --- Use toZDateString() to see all of the elements of your time			trace( zDate.toZDateString());						// --- manually get/set date elements --------------------------------------------------------------------			//					//		year			:int		2-digit and 4-digit representations			// 		month			:*			common abbreviations, fullname, and month-number			//		day				:int		numerical day of month			//		hour			:int		24 hour format			//		minute			:int		0-59			//		second			:int		0-59			//		timezoneOffset	:int 		in seconds			//		weekday			:String		common abbreviations and fullname			//						// --- adding/subtracting dates --------------------------------------------------------------------------			//			//		Use these setters to add/subtract your dates. They should rollover and refactor accordingly.				//			//		year			:+/-int			//		month			:+/-int			//		day				:+/-int			//		hour			:+/-Number	(decimal values ok)			//		minute			:+/-Number	(decimal values ok)			//		second			:+/-Number	(but it rounds to the nearest second ;)			//			zDate.hour += 100.5;			trace( zDate.toZDateString());		}	}	}