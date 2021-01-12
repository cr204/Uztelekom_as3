package com.uzbilling.controller {
	
	import com.uzbilling.pages.*;
	
	public class PageManager {
		private static var instance:PageManager;
		private static var allowInstance:Boolean;
		
		public function PageManager() {
			// constructor code
			if(!allowInstance) {
				throw new Error("Error: use PageManager.getInstance() instead of new keyword");
			}
		}
		
		public static function getInstance():PageManager {
			if(instance == null) {
				allowInstance = true;
				instance = new PageManager();
				allowInstance = false;
				return instance;
			} else {
				//trace("PageManager instance already exists");
			}
			return instance;
		}
		
		public function getPage(pg:String):Page {
			var page:Page;
			
			switch(pg) {
				case "welcome":
					page = new PageWelcome();
					break;
				case "login":
					page = new PageLogin();
					break;
				case "code":
					page = new PageEnterCode();
					break;
				case "tarifs":
					page = new PageTarifs();
					break;
				case "traffic":
					page = new PageTraffic();
					break;
				case "internet_payments":
					page = new PageInternetPayments();
					break;
				case "tariff_history":
					page = new PageTariffHistory();
					break;
				case "userInfo":
					page = new PageUserInfo();
					break;
				case "subscriber":
					page = new PageUserInfo();
					break;
				case "services":
					page = new PageServices();
					break;
				case "service_payment":
					page = new PageServicePayment();
					break;
				case "payments":
					page = new PagePayments();
					break;
				case "statistics":
					page = new PageStatistics();
					break;
				case "additionals":
					page = new PageAdditionals();
					break;
				default:
					page = new Page();
					trace("PageManager.getPage() error: " + pg);
					break;
			}
			return page;
		}

		
	}
}