import 'package:flutter/material.dart';

class HouseValue {
  const HouseValue();

  static En of(BuildContext context) {
    switch (Localizations.localeOf(context).languageCode) {
      case 'en':
        return En();
      case 'zh':
        return Zh();
    }
    return En();
  }
}

class Zh extends En {
  String signIn = "登录";
  String email = "邮箱";
  String typeYourEmailAddress = "请输入您的邮箱地址";
  String password = "密码";
  String newPassword = "新密码";
  String typeNewPassword = "请输入新密码";
  String confirmPassword = "确认密码";
  String typeYourPassword = "请输入您的密码";
  String retypeYourPassword = "请再输入密码";
  String forgetPassword = "忘记密码?";
  String doNotHaveAnAccount = "没有账户?";
  String signUp = "注册";
  String send = "发送";
  String sendEmailNotice = "输入您的电子邮件地址，我们会给您发送一封带有密码的电子邮件。";
  String emailSent = "邮件发送";
  String emailSentNotice = "请登录你的邮箱: \n###\n确认新的账密码";
  String emailSentOK = "OK , 请使用新密码登录";
  String pleaseEnterYourRegistrationCode = "请输入验证码";
  String next = "下一步";
  String doNotHaveARegistrationCode = "没有注册邀请码>";
  String identity = "身份";
  String chooseYourIdentity = "选择身份";
  String verificationCode = "验证码";
  String typeVerificationCode = "请输入验证码";
  String sendVerificationCodeToMyEmail = "发送邮箱验证码";
  String passwordError = "确认密码不正确";
  String codeError = "验证码错误";
  String bySigningUpIAgreeToThe = "By signing up, I agree to the ";
  String privacyPolicy = " Privacy Policy ";
  String and = "and";
  String conditionsOfUse = " Conditions of Use.";
  List<String> identities = ["中介", "房东", "房客", "维修商"];
  String systemException = "系统异常";

  String properties = "需求";
  String task = "任务";
  String vendor = "维修商";
  String me = "我";
  String back = "返回";
  String profile = "个人信息";
  String settings = "设置";
  String notifications = "通知消息";
  String changeEmail = "更换邮箱";
  String changePassword = "修改密码";
  String save = "保存";
  String notificationPush = "消息推送";
  String clearCache = "清除缓存";
  String aboutUs = "关于我们";
  String logOut = "Log Out";

  List<String> certificateString = [
    "无资质",
    "审核中",
    "审核通过",
    "审核未通过",
  ];
  String companyInfo = "公司信息";
  String photo = "公司Logo";
  String name = "公司名称";
  String area = "区域";
  String city = "城市";
  String phone = "电话";
  String address = "地址";
  String detail = "公司简介";
  String submit = "提交";
  String certificateNotice = "请上传你的资格证书";
  String pleaseEnterThe = "请输入";
  String type = "类型";
  String licenseNo = "证书编号";
  String expireDate = "过期时间";
  String firstName = "名";
  String lastName = "姓";
  String typeFirstName = "输入名";
  String typeLastName = "输入姓";
  String typePhone = "输入电话";
  String repairDetail = "房屋维修";
  String description = "问题描述";
  String pleaseUploadPhotos = "上传图片";
  String houseDetail = "房屋详情";
  String sQft = " sqft";
  String car = " car";
  String built = "Build in ";
  String bed = " bed";
  String bath = " bath";
  String contractNo = "Contract No. :";
  String features = "Features";
  String map = "Map";
  String list = "List";
  String filter = "Filter";
  String publish = "Publish";
  String processing = "Processing";
  String taskView = "Task View";
  String taskDescription = "Question Description";
  String byPass = "Bypass";
  String finished = "Finish";
  String cases = "Case";
  String orders = "Orders";
  String orderDetail = "Order Detail";
  String referenceOfAgency = "Reference of Agency";
  String quote = "Quote";
  String quotation = "Quotation:";
  String quotationDetail = "quotation detail";
  String chooseAVendor = "Choose a vendor";
}

class En {
  String signIn = "Sign In";
  String email = "Email";
  String typeYourEmailAddress = "Type youre email address";
  String isNotEmail = "Is not email ?";
  String password = "Password";
  String confirmPassword = "Confirm password";
  String newPassword = "New password";
  String typeNewPassword = "Type new password";
  String typeYourPassword = "Type your password";
  String passwordLengthMoreThan6 = "Password length more than 6 ?";
  String retypeYourPassword = "Retype your password";
  String forgetPassword = "Forget password?";
  String doNotHaveAnAccount = "Don’t have an account?";
  String signUp = "Sign up";
  String send = "Send";
  String sendEmailNotice =
      "Enter your email address and we will send you an email with password.";
  String emailSent = "E-mail Sent";
  String emailSentNotice =
      "Please sign in your e-mail\n###\nto check your new password";
  String emailSentOK = "OK , got it";
  String pleaseEnterYourRegistrationCode =
      "Please enter your registration code";
  String next = "Next";
  String doNotHaveARegistrationCode = "Don’t have a registration code >";
  String identity = "Identity";
  String chooseYourIdentity = "Choose your identity";
  String verificationCode = "Verification code";
  String typeVerificationCode = "Type Verification Code";
  String sendVerificationCodeToMyEmail = "Send Verification Code to my Email";
  String passwordError = "Verify that the password is incorrect";
  String codeError = "Verification code error";
  String bySigningUpIAgreeToThe = "By signing up, I agree to the ";
  String privacyPolicy = " Privacy Policy ";
  String and = "and";
  String conditionsOfUse = " Conditions of Use.";
  List<String> identities = ["Agency", "Landlord", "Tenant", "Vendor"];
  String systemException = "System exception";
  String properties = "Properties";
  String task = "Task";
  String vendor = "Vendor";
  String me = "Me";
  String back = "Back";
  String profile = "Profile";
  String settings = "Settings";
  String notifications = "Notifications";
  String changeEmail = "Change Email";
  String changePassword = "Change Password";
  String save = "Save";
  String notificationPush = "Notification Push";
  String clearCache = "Clear Cache";
  String aboutUs = "About Us";
  String logOut = "Log Out";
  String company = "Company";
  String companyInfo = "Company Info";
  String photo = "Photo";
  String name = "Name";
  String area = "Area";
  String city = "City";
  String phone = "Phone";
  String address = "Address";
  String detail = "Detail";
  String submit = "Submit";
  String certificate = "Certificate";
  String certificateNotice = "Please upload your qualification certificate";
  String pleaseEnterThe = "Please enter the ";
  String type = "Type";
  String licenseNo = "License No.";
  String expireDate = "Expire Date";
  String firstName = "First Name";
  String lastName = "Last Name";
  String typeFirstName = "Type First Name";
  String typeLastName = "Type Last Name";
  String typePhone = "Type Phone";
  String repairDetail = "Repair Detail";
  String title = "Title";
  String description = "Description";
  String pleaseUploadPhotos = "Please upload photos";
  String houseDetail = "House Detail";
  String sQft = " sqft";
  String car = " car";
  String built = "Build in ";
  String bed = " bed";
  String bath = " bath";
  String contractNo = "Contract No. :";
  String features = "Features";
  String map = "Map";
  String list = "List";
  String orderList = "Order List";
  String filter = "Filter";
  String publish = "Publish";
  String processing = "Processing";
  String taskView = "Task View";
  String taskDescription = "Task Description";
  String byPass = "Bypass";
  String finished = "Finished";
  String close = "Close";
  String unFinished = "Unfinished";
  String cases = "Cases";
  String orders = "Orders";
  String orderDetail = "Order Detail";
  String referenceOfAgency = "Reference of Agency";
  String quote = "Quote";
  String quotation = "Quotation:";
  String quotationDetail = "quotation detail";
  String chooseAVendor = "Choose a vendor";
  String taskList = "Task List";
  String accept = "accept";
  String authNotice =
      "Are you sure you authorized the mediation to handle this? Once confirmed, you will not be able to select a vendor on this page!";
  String cancel = "Cancel";
  String ok = "Ok";
  String authProcessing = "The landlord has authorized the processing";
  String authorizedAgency = "Authorized agency";
  String areYouSureToChoose = "Are you sure to choose “#”?";
  String submitRepairResults = "Submit repair results";
  String repairResults = "Repair Results";
  String vendorList = "Vendor List";
  String vendorDetail = "Vendor Detail";
  String message = "Message";
  String leaveAMessage = "leave a message: ";
  String orderNo = "Order No. ";
  String areYouOkToExitTheApplication = "Are you ok to exit the application？";
  String areYouOk = "Are you ok to #？";
  String skip = "Skip";
  String success = "Success";
  String delete = "Delete";
  String modify = "Modify";
  String areYouSureToDeleteThisCertificate =
      "Are you sure to delete this certificate ?";
  String areYouSureToModifyThisCertificate =
      "Are you sure to modify this certificate ?";
}
