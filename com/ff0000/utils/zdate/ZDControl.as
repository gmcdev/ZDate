﻿package com.ff0000.utils.zdate {	import flash.events.Event;	public class ZDControl {		private var zdModel:ZDModel;		private var zdUtil:ZDUtil;		private var zdTrace:ZDTrace;		// constructor 		public function ZDControl() {			zdModel = ZDModel.getInstance();			zdModel.addEventListener( 'propagateTimestampToDateElements', propagateTimestampToDateElements );			zdModel.addEventListener( 'propagateDateElementsToTimestamp', propagateDateElementsToTimestamp );			zdUtil = new ZDUtil();			zdTrace = ZDTrace.getInstance();		}		/* -- CONVERSION METHODS ----------------------------------------------------------------------------------------		 *		 *		 *		 */		// convert to date elements from string		internal function convertToDateElementsFrom( $_string:String ):void {			zdTrace.log( this+' convertToDateElementsFrom( "'+$_string+'" )', 1 );			parseYear( $_string );			parseCalendarDate( $_string );			parseTimeOfDay( $_string );			parseDayOfWeek( $_string );		}						/* -- PROPAGATION METHODS ----------------------------------------------------------------------------------------		 *		 *		These keep timestamp synced with date elements and vice versa		 *		 */		// propagate date elements to timestamp		internal function propagateDateElementsToTimestamp( $_e:Event = null ):void {			zdTrace.log( this+' propagateDateElementsToTimestamp( '+$_e+' )', 1 );			var _cummulativeSeconds:int = zdModel.second;			_cummulativeSeconds += zdUtil.minutesToSeconds( zdModel.minute );			_cummulativeSeconds += zdUtil.hoursToSeconds( zdModel.hour );			_cummulativeSeconds += zdUtil.daysToSeconds( zdModel.day-1 );			for( var i:int = 0; i < zdModel.month-1; i++ ) {				_cummulativeSeconds += zdUtil.daysToSeconds( zdUtil.daysInMonthOf( i, zdModel.year ));			}			for( var j:int = 1970; j < zdModel.year; j++ ) {				_cummulativeSeconds += zdUtil.daysToSeconds( zdUtil.daysInYear( j ));			}			_cummulativeSeconds -= zdModel.timezoneOffset;			zdModel.setTimestamp( _cummulativeSeconds );			zdModel.setWeekday( 				zdModel.WEEKDAYS_FULL[zdUtil.determineWeekdayIndexFrom( zdModel.month, zdModel.day, zdModel.year )]			);		}				// propagate timestamp to date elements		internal function propagateTimestampToDateElements( $_e:Event = null ):void {			zdTrace.log( this+' propagateTimestampToDateElements( '+$_e+' )', 1 );			var _timeIncludingTimezoneOffset:int = zdModel.timestamp + zdModel.timezoneOffset;			var _result:Object = zdUtil.extractYearsFrom( _timeIncludingTimezoneOffset );			zdModel.setYear( _result.years );						_result = zdUtil.extractMonthsFrom( _result.remainingSeconds, zdModel.year );			zdModel.setMonth( _result.months );						_result = zdUtil.extractDaysFrom( _result.remainingSeconds );			zdModel.setDay( _result.days );						_result = zdUtil.extractHoursFrom( _result.remainingSeconds );			zdModel.setHour( _result.hours );						_result = zdUtil.extractMinutesFrom( _result.remainingSeconds );			zdModel.setMinute( _result.minutes );			zdModel.setSecond( _result.remainingSeconds );						zdModel.setWeekday( 				zdModel.WEEKDAYS_FULL[zdUtil.determineWeekdayIndexFrom( zdModel.month, zdModel.day, zdModel.year )]			);		}												/* -- DATE STRING PARSING METHODS ------------------------------------------------------------------------------------		 *		 *		date strings are parsed according to the gnu.org spec		 *		found here --> http://www.gnu.org/software/automake/manual/tar/Date-input-formats.html#SEC119		 *		 */		// parse string for 4 digit year		internal function parseYear( $_string:String ):void {			// year			var _matches:Array = $_string.match( /(\A|\s)[0-9]{4}(\Z|\s)/g );			if( _matches.length > 0 ) {				zdTrace.log( this+'  - yyyy', 1 );				zdModel.setYear( _matches[0] );				return;			}		}				// parse strings that follow the gnu.org spec for Calendar Dates		internal function parseCalendarDate( $_string:String ):void {			var _year:int;			var _month:int;			var _day:int;			var _matches:Array;			var _parts:Array;			// yyyy-mm-dd			_matches = $_string.match( /[0-9]{1,4}-[0-9]{1,2}-[0-9]{1,2}/g );			if( _matches.length > 0 ) {				zdTrace.log( this+'  - yyyy-mm-dd', 1 );				_parts = _matches[0].split( '-' );				zdModel.setYear( parseInt( _parts[0] ));				zdModel.setMonth( parseInt( _parts[1] ));				zdModel.setDay( parseInt( _parts[2] ));				return;			}			// mm/dd/yyyy			_matches = $_string.match( /[0-9]{1,2}\/[0-9]{1,2}\/?[0-9]{0,4}/g );			if( _matches.length > 0 ) {				zdTrace.log( this+'  - mm/dd/yyyy', 1 );				_parts = _matches[0].split( '/' );				zdModel.setMonth( parseInt( _parts[0] ));				zdModel.setDay( parseInt( _parts[1] ));				if( _parts[2] )					zdModel.setYear( parseInt( _parts[2] ));				else zdModel.setYear( zdModel.DEFAULT_YEAR );				return;			}			// dd textual-month yyyy			_matches = $_string.match( /[0-9]{1,2}\s[a-z]+\s[0-9]{0,4}/gi );			if( _matches.length > 0 ) {				zdTrace.log( this+'  - dd textual-month yyyy', 1 );				_parts = _matches[0].split( ' ' );				zdModel.setDay( parseInt( _parts[0] ));				zdModel.setMonth( _parts[1] );				if( _parts[2] )					zdModel.setYear( parseInt( _parts[2] ));				else zdModel.setYear( zdModel.DEFAULT_YEAR );				return;			}			// textual-month dd			_matches = $_string.match( /[a-z]+\s[0-9]{1,2}/gi );			if( _matches.length > 0 ) {				zdTrace.log( this+'  - textual-month dd', 1 );				_parts = _matches[0].split( ' ' );				zdModel.setMonth( _parts[0] );				zdModel.setDay( parseInt( _parts[1].replace( /,/, '' )));				if( _parts[2] )					zdModel.setYear( parseInt( _parts[2] ));				else zdModel.setYear( zdModel.DEFAULT_YEAR );				return;			}		}				// parse times of day that follow the gnu.org spec for Time of Day Items		internal function parseTimeOfDay( $_string:String ):void {			var _matches:Array;			var _parts:Array;			// hh am/pm			_matches = $_string.match( /[0-9]{1,2}(:[0-9]{2})?\s?(am|pm)/gi );			if( _matches.length > 0 ) {				zdTrace.log( this+'  - hh(:mm)||(am/pm)', 1 );				var _meridiem:String = 'am';				_parts = _matches[0].split( ':' );				if( _parts.length == 1 ) {					zdModel.setHour( _parts[0].match( /[0-9]{1,2}/ )[0] );					_meridiem = _parts[0].match( /[a-z]{2}/i )[0];				}				else if( _parts.length == 2 ) {					zdModel.setHour( _parts[0].match( /[0-9]{1,2}/ )[0] );					zdModel.setMinute( _parts[1].match( /[0-9]{1,2}/ )[0] );					_meridiem = _parts[1].match( /[a-z]{2}/i )[0];				}				if( _meridiem == 'pm' && zdModel.hour < 12 ) {					zdModel.hour += 12;				}				assumeClientTimezoneOffset();				return;			}			// hh:mm:ss			_matches = $_string.match( /[0-9]{1,2}:[0-9]{1,2}(:[0-9]{1,2})?(\s?(utc|gmt|z)?(-|\+)[0-9]{1,2}:?[0-9]{2})?/gi );			if( _matches.length > 0 ) {				zdTrace.log( this+'  - hh:mm:ss', 1 );				_parts = _matches[0].split( ':' );				var _tzOffset:Array = new Array();				if( _parts.length == 2 ) {					zdModel.setHour( _parts[0] );					zdModel.setMinute( _parts[1].match( /[0-9]{2}/ )[0] );						_tzOffset = _parts[1].match( /(utc|gmt|z)?(-|\+)[0-9]{2}:?[0-9]{2}/gi );				}				else if( _parts.length == 3 ) {					zdModel.setHour( _parts[0] );					zdModel.setMinute( _parts[1] );					zdModel.setSecond( _parts[2].match( /[0-9]{2}/ )[0] );					_tzOffset = _parts[2].match( /(utc|gmt|z)?(-|\+)[0-9]{2}:?[0-9]{2}?/gi );				}				if( _tzOffset.length > 0 ) {					zdTrace.log( this+'  - (utc/gmt/z) (+/-) hhmm', 1 );					interpretTimezoneOffset( _tzOffset[0] );				}				else {					assumeClientTimezoneOffset();				} 								return;			}		}				// interpret timezone offset string		internal function interpretTimezoneOffset( $_tzOffset:String ):void {			zdTrace.log( this+' interpretTimezoneOffset( "'+$_tzOffset+'" )', 1 );			var _tzParts:Array = $_tzOffset.match( /(-|\+)[0-9]{2}:?[0-9]{2}?/g );			var _tzOffsetMinutes:int = _tzParts.length ? parseInt( _tzParts[0].substring( _tzParts[0].length-2, _tzParts[0].length )) : 0;			var _tzOffsetHours:int = _tzParts.length ? parseInt( _tzParts[0].substring( 0, _tzParts[0].length-2 )) : 0;			var _tzOffsetSeconds:int = zdUtil.hoursToSeconds( _tzOffsetHours ) + zdUtil.minutesToSeconds( _tzOffsetMinutes );			if( zdModel.correctForDst ) { 				var _dstOffset:int = zdUtil.hoursToSeconds( zdUtil.getDstOffsetFor( zdModel.timestamp ));				zdModel.setTimezoneOffset( _tzOffsetSeconds + _dstOffset );				zdModel.correctForDst = false;			}			else {				zdModel.setTimezoneOffset( _tzOffsetSeconds );			}		}				// assume client timezone offset		internal function assumeClientTimezoneOffset():void {			zdTrace.log( this+' assumeClientTimezoneOffset()', 1 );			var _clientOffsetWithoutDst:int = zdUtil.getClientTimezoneOffsetInMinutes();			var _sign:int = _clientOffsetWithoutDst > 0 ? 1 : -1;			var _hoursOffset:int = Math.floor( Math.abs( _clientOffsetWithoutDst ) / 60 );			var _minutesOffset:int = Math.abs( _clientOffsetWithoutDst ) - _hoursOffset*60;						var _tzOffsetSeconds:int = _sign * ( zdUtil.hoursToSeconds( _hoursOffset ) + zdUtil.minutesToSeconds( _minutesOffset ));			var _dstOffset:int = zdUtil.hoursToSeconds( zdUtil.getDstOffsetFor( zdModel.timestamp ));			zdModel.setTimezoneOffset( _tzOffsetSeconds + _dstOffset );		}				// parse day of week that follow the gnu.org spec for Sec7.5 Day of Week Items		internal function parseDayOfWeek( $_string:String ):void {			var regex:String = '';			for( var i:int = 0; i < zdModel.WEEKDAYS_FULL.length; i++ ) {				regex += zdModel.WEEKDAYS_FULL[i] + '|';				regex += zdModel.WEEKDAYS_ABRV[i] + '|';				if( zdModel.WEEKDAYS_EXCP1[i] != '' )					regex += zdModel.WEEKDAYS_EXCP1[i] + '|';				if( zdModel.WEEKDAYS_EXCP2[i] != '' )					regex += zdModel.WEEKDAYS_EXCP2[i] + '|';			}			regex = regex.slice( 0, regex.length-1 );			var pattern:RegExp = new RegExp( regex, 'i' );			var _matches:Array = $_string.match( pattern );			if( _matches ) {				zdModel.setWeekday( _matches[0] );			}		}			}	}