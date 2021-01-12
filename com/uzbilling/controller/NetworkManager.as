package com.uzbilling.controller {
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import com.uzbilling.events.NetworkDataEvent;
	import flash.events.IOErrorEvent;
	import com.uzbilling.model.SelectList;
	import com.uzbilling.model.PhoneList;
	import flash.net.URLVariables;
	import flash.net.URLRequestMethod;
	import flash.net.URLRequestHeader;
	
	import com.uzbilling.model.Globals;
	
	
	public class NetworkManager {
		private static var instance:NetworkManager;
		private static var allowInstance:Boolean;
		
		public const ZAYAVKA_URL:String = "http://support.uzbilling.uz/index.php?sub=pphn_case";
		public const SERVER:String = "http://185.74.4.145:8090/cabinet/";
		public const SERVER0:String = "http://185.74.4.145:8090/";
		public const USER_AUTH:String = SERVER + "auth";
		public const CODE_SEND:String = SERVER + "sendsms";
		public const CODE_RESEND:String = SERVER + "pcrconfirm";
		public const SUBSCRIBER_PATH:String = SERVER + "subscriber";
		
		private const LANGUAGE_SETTINGS:String = "/settings/language.txt";
		private const TARIFS_PATH:String = SERVER + "tarifs";
		private const TRAFFIC_PATH:String = SERVER + "traff";
		private const IPAYMENTS_PATH:String = SERVER + "payments";
		private const TARIF_HIST_PATH:String = SERVER + "tariffHist";
		private const CHANGE_TARIFF_PATH:String = SERVER + "changeTariff";
		private const FILTER_LIST:String = SERVER + "pcFltrList";
		private const REFRESH_PATH:String = SERVER + "pcmain&lc=" + LanguageSettings.getInstance().getLangPfx();
		private const SERVICES_PATH:String = SERVER + "pcdata?pcd=subscriber_gs&page=1&rows=100";
		private const SPAYMENT_PATH:String = SERVER + "pcdata?pcd=subscr_debet&rows=100&page=1";
		private const PAYMENTS_PATH:String = SERVER + "pcdata?pcd=subscr_payments&rows=100&page=1";
		private var STATS_PATH:String = SERVER + "pcdata?pcd=subscr_mty_tell&_search=true&rows=100&page=1&sord=asc&filters={%22p_start_in%22:%2245%22,%22p_end_in%22:%2246%22,%22p_phone_a_in%22:%22%22,%22p_phone_b_in%22:%22%22}";
		private const ADDITIONALS_PATH:String = SERVER + "pcdata?pcd=subscr_dbo&rows=40&page=1&tellSubscr=";
		private const ADD_DESCRIPT_PATH:String = SERVER + "pcSdescr?t=";
		private const SERVICE_ACTION_PATH:String = SERVER + "pcServiceAction"; //?t=";
		private static var returnedData:String = "";
		private static var SEL_NUMBER:int = 0;
		
		public function NetworkManager() {
			// constructor code
			if(!allowInstance) {
				throw new Error("Error: use NetworkManager.getInstance() instead of new keyword");
			}
		}
		
		public static function getInstance():NetworkManager {
			if(instance == null) {
				allowInstance = true;
				instance = new NetworkManager();
				allowInstance = false;
				return instance;
			} else {
				//trace("NetworkManager instance already exists");
			}
			return instance;
		}
		
		public function requestFor(s:String, sid:String="", st:String=""):void {
			
			trace("NM.requestFor: " + s);
			
			var mesObject:Object;
			
			var path:String
			switch(s) {
				case "subscriber":
					path = SUBSCRIBER_PATH;
					break;
				case "services":
					path = SERVICES_PATH;
					break;
				case "tarifs":
					path = TARIFS_PATH;
					break;
				case "traffic":
					path = TRAFFIC_PATH;
					mesObject = getDateInterval();
					break;
				case "internet_payments":
					path = IPAYMENTS_PATH;
					mesObject = getDateInterval();
					break;
				case "service_payment":
					path = SPAYMENT_PATH;
					break;
				case "tariff_history":
					path = TARIF_HIST_PATH;
					break;
				case "payments":
					path = PAYMENTS_PATH;
					break;
				case "changeTariff":
					path = CHANGE_TARIFF_PATH;
					mesObject = getTariffIDs(sid);
					break;
				case "statistics":
					path = STATS_PATH;
					break;
				case "additionals":
					path = ADDITIONALS_PATH + PhoneList.getInstance().getSelectedPhoneNumber();
					break;
				case "description":
					path = ADD_DESCRIPT_PATH + PhoneList.getInstance().getPhoneID(SEL_NUMBER) + "&d=" + sid;
					path += "&a=" + (LanguageSettings.getInstance().getLangPfx());
					break;
				case "serviceAction":
					path = SERVICE_ACTION_PATH;  // + PhoneList.getInstance().getPhoneID(SEL_NUMBER) + "&gid=" + sid;
					//path += "p={}&a=" + st
					break;
				case "userInfo":
					trace("FIX-ME! NetworkManager.requestFor(). User info must be solved here!!!")
					break;
				default:
					path = "unknown";
					trace("Warning!!! Unknown request type:" + s + " in NetworkManager.requestFor()");
					break;
				
			}
			
			 if(path!="unknown") {
				returnedData = "not_loaded";
				trace(path);
				 
				 
				var hdr0:URLRequestHeader = new URLRequestHeader("Content-type", "application/json");
				var hdr1:URLRequestHeader = new URLRequestHeader("X-Access-token", Globals.getInstance().token);
				var hdr2:URLRequestHeader = new URLRequestHeader("Cache-Control", "no-cache");
				
				 
				var req:URLRequest = new URLRequest(path);
				req.requestHeaders.push(hdr0);
				req.requestHeaders.push(hdr1);
				req.requestHeaders.push(hdr2);
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
				urlLoader.addEventListener(Event.COMPLETE, requestLoadHandler);
				 
				 
				req.method = URLRequestMethod.POST;
				 
				if(mesObject) {
					var jsonString:String = JSON.stringify(mesObject);
					req.data = jsonString; 
				}
				
/*				var variables:URLVariables = new URLVariables();
				variables.tellSubscr = PhoneList.getInstance().getSelectedPhoneNumber(); //.getPhoneID(SEL_NUMBER);
				variables.gid = sid;
				variables.p = "";
				variables.a = st;
				variables.pcd = "subscr_dbo";
				variables.rows = "40"
				variables.page = "1"
				req.data = variables;  */

				
/*				trace("## --> POST:");
				trace("## tellSubscr: " + variables.tellSubscr);
				trace("## gid: " + variables.gid);
				trace("## p: " + variables.p);
				trace("## a: " + variables.a);
				trace("## pcd: " + variables.pcd);
				trace("## rows: " + variables.rows);
				trace("## page: " + variables.page);
				trace("## -->");  */
					
				urlLoader.load(req);
			}
		}
		
		public function langSettingsPath():String {
			return LANGUAGE_SETTINGS;
		}
		
		public function selectFilterList():String {
			return FILTER_LIST;
		}
		
		public function selectedNumber(n:int):void {
			SEL_NUMBER = n;
		}
		
		private function requestLoadHandler(e:Event):void {
			var mainData:String = e.target.data;
			
			//trace("NM.requestLoadHandler: " + mainData);
			
			if(mainData.length==13 && mainData.search("401")>0) {
				trace("LOGIN required!");
				mainData = "login_required";
			}
			
			returnedData = mainData;
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void {
			returnedData = "no_connection";
		}
		
		public function getReturnedData():String {
			return returnedData;
		}
	
		private function getDateInterval():Object {
			var tempObject:Object =
			{
				"date_beg":Globals.getInstance().date_begin,
				"date_end":Globals.getInstance().date_end
			};
			return tempObject;
		}
		
		private function getTariffIDs(sid:String):Object {
			var tempObject:Object =
			{
				"curTId":Globals.getInstance().tariff_id,
				"newTid":sid
			};
			return tempObject;
		}
	}
}