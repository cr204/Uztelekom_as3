package com.uzbilling.controller {
	
	import com.uzbilling.view.PopUp;
	import com.uzbilling.view.PopUpNoConnection;
	import com.uzbilling.view.PopUpLanguage;
	import com.uzbilling.view.PopUpSelect;
	import com.uzbilling.model.SelectList;
	import com.uzbilling.view.PopUpChangePassword;
//	import com.uzbilling.view.PopUpHelp;
	import com.greensock.easing.*;
	import com.uzbilling.view.PopUpAbout;
	import com.uzbilling.view.PopUpDetails;
	import com.uzbilling.view.PopUpServiceConfirm;
	import com.uzbilling.model.PhoneList;
	import com.uzbilling.view.PopUpLogin;
	import com.uzbilling.view.PopUpOnlinePayment;
	
	public class PopUpManager {
		private static var instance:PopUpManager;
		private static var allowInstance:Boolean;
		
		public function PopUpManager() {
			// constructor code
			if(!allowInstance) {
				throw new Error("Error: use PopUpManager.getInstance() instead of new keyword");
			}
		}
		
		public static function getInstance():PopUpManager {
			if(instance == null) {
				allowInstance = true;
				instance = new PopUpManager();
				allowInstance = false;
				return instance;
			} else {
				//trace("PageManager instance already exists");
			}
			return instance;
		}
		
		public function getPopUp(pu:String):PopUp {
			var popUp:PopUp;
			
			switch(pu) {
				case "no_connection":
					popUp = new PopUpNoConnection();
					break;
				case "incorrect_code":
					popUp = new PopUpNoConnection();
					popUp.updateTexts("Invalid Code", "Please enter correct code");
					break;
				case "changePass":
					popUp = new PopUpChangePassword();
					//popUp = new PopUpOnlinePayment();
					break;  
				case "language":
					popUp = new PopUpLanguage();
					popUp.updateTexts(LanguageSettings.getInstance().getData("pop.lang"), "");
					break;
				case "about":
					popUp = new PopUpAbout();
					break;
				case "details":
					popUp = new PopUpDetails();
					break;
				case "select":
					popUp = new PopUpSelect();
					popUp.setData(SelectList.DATE_ARRAY);
					break;
				case "serviceConfirm":
					popUp = new PopUpServiceConfirm
					break;
				case "phoneList":
					popUp = new PopUpSelect();
					popUp.setData(PhoneList.DATA_ARRAY);
					break;
				case "login_required":
					popUp = new PopUpLogin();
					break;
					
				default:
					popUp = new PopUp();
					trace("PopUpManager.getPopUp() error: " + pu);
					break;
			}
			
			return popUp;
		}
		
	}
}