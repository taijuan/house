import 'package:flutter/material.dart';

class HouseValue {
  static En of(BuildContext context) {
    switch (Localizations.localeOf(context).languageCode) {
      case 'en':
        return En();
    }
    return En();
  }
}

class En {
  String signIn = "Sign In";
  String email = "Email";
  String typeYourEmailAddress = "Type youre email address";
  String isNotEmail = "Is not email ?";
  String password = "Password";
  String confirmPassword = "Confirm password";
  String confirm= "Confirm";
  String newPassword = "New password";
  String typeNewPassword = "Type new password";
  String typeYourPassword = "Type your password";
  String passwordLengthMoreThan6 = "Password length more than 6 ?";
  String retypeYourPassword = "Retype your password";
  String forgetPassword = "Forget password?";
  String doNotHaveAnAccount = "Don’t have an account?";
  String signUpForVendor = "Sign up for vendor?";
  String signUpFromCode = "Sign up from invitation code?";
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
  String companyName = "Company Name";
  String companyInfo = "Company Info";
  String photos = "Photos";
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
  String caseDetail = "Case Detail";
  String byPass = "Bypass";
  String resolve = "Resolve";
  String allResolve = "All Resolve";
  String close = "Close";
  String unFinished = "Unfinished";
  String cases = "Cases";
  String orders = "Orders";
  String orderDetail = "Order Detail";
  String referenceOfAgency = "Reference of Agency";
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
  String areYouSure = "Are you sure?";
  String skip = "Skip";
  String success = "Success";
  String delete = "Delete";
  String modify = "Modify";
  String areYouSureToDeleteThisCertificate =
      "Are you sure to delete this certificate ?";
  String areYouSureToModifyThisCertificate =
      "Are you sure to modify this certificate ?";

  String areYouSureToDeleteThisCase = "Are you sure to delete this case ?\n#";

  String areYouSureToDeleteThisOrder = "Are you sure to delete this order ?\n#";
  String inquiries = "Inquiries";
  String quote = "Quote";
  String job = "Job";
  String publishDate = "Publish Date";
  String allRequests = "All Requests";
  String orderView = "Order View";
  String allOrder = "All Orders";
  String propertyType = "Property Type";
}
