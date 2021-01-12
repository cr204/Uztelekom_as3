package com.uzbilling.model {

	public class IPaymentsModel {
		public var regis_date:String;
		public var emp_name:String;
		public var acc_id:String;
		public var type_id:String;
		public var id:String;
		public var regis_n:String;
		public var date_edit:String;
		public var amount:String;
		public var type_name:String;
		public var can_del:String;
		private var rex:RegExp = /[\s\r\n]+/gim;
		
		public function IPaymentsModel() {
			// constructor code
		}
		
		public function setObject(obj:Object):void {
			regis_date = obj.REGIS_DATE.replace(rex,'');
			emp_name = obj.EMP_NAME.replace(rex,'');
			acc_id = obj.ACC_ID;
			type_id = obj.TYPE_ID.replace(rex,'');
			id = obj.ID_.replace(rex,'');
			regis_n = obj.REGIS_N;
			date_edit = obj.DATE_EDIT.replace(rex,'');
			amount = obj.AMOUNT_;
			type_name = obj.TYPE_NAME;
			can_del = obj.CAN_DEL;
		}		
	}
	
}