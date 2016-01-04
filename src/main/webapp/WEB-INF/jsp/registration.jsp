<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page isELIgnored="false"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet"
	href="<c:url value="/tutorials/css/pure-forms-edited.css"/>">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>	
<script src="<c:url  value="/tutorials/js/bits.js"/>"></script>
<script type="text/javascript">

/**
 * Notice, how to refactor script by adding "lambda ex" to pass function into function
 */
	/**
	* FLAGS which specify a correctness of all form pools
	*/
	var LOGIN_CORRECT_BIT 		= 0;
	var PASSWORD_CORRECT_BIT 	= 1;
	var SAME_PASSWORD_BIT		= 2;
	var NAME_CORRECT_BIT		= 3;
	var SURNAME_CORRECT_BIT		= 4;
	var EMAIL_CORRECT_BIT		= 5;
	var INDEX_CORRECT_BIT		= 6;
	
	var REGISTRATION_CORRECTNESS_FULL = 127;
	
	var PASSWORD_ERROR = "Login must be from 8 to 24 signs and contains at least one downcase,uppercase and digit!";
	var LOGIN_ERROR = "Login must be beetwen 6-30 signs!";
	var LOGIN_BUSY = "This login is busy. Please choose another one!";
	var NOT_SAME_PASSWORD = "Password are not the same!"
	var NAME_ERROR = "Name must be 2 to 30 signs!";
	var EMAIL_ERROR = "Email is incorrect!";
	var INDEX_ERROR = "Index Number is incorrect!";
	
	var correctnessStatus = 0;
	
	$(function(){
		$("#user-details").hide();		
		
		$("#login").on('change',function(){
			var login = $("#login").val();			
			if(!isLoginCorrect(login)){
				showError("login",LOGIN_ERROR);
				correctnessStatus = clearFlag(correctnessStatus,LOGIN_CORRECT_BIT);				
			}
			else
			{
				correctnessStatus = setFlag(correctnessStatus,LOGIN_CORRECT_BIT);
				showCorrect("login");
			}
		
			notifyRegistration();
		});
		
		$("#password").on('change',function(){
			correctnessStatus = resetPasswordsFlagsAndClearRePassword(correctnessStatus);			
			password = $("#password").val();
			if(!isPasswordCorrect(password)){
				showError("password",PASSWORD_ERROR);
			}
			else{
				correctnessStatus = setFlag(correctnessStatus,PASSWORD_CORRECT_BIT);
				showCorrect("password");
			}			
			notifyRegistration();
		});
		
		$("#re-password").on("change",function(){
			var password = $("#password").val();
			var rePassword = $("#re-password").val();
			if(password == rePassword){
				showCorrect("re-password");
				correctnessStatus = setFlag(correctnessStatus,SAME_PASSWORD_BIT);
			}
			else{
				showError("re-password", NOT_SAME_PASSWORD);
				correctnessStatus = clearFlag(correctnessStatus,SAME_PASSWORD_BIT);
			}
			notifyRegistration();
		});
		
		$("#submit-button").on("click",function(){
			alert(correctnessStatus+" "+REGISTRATION_CORRECTNESS_FULL);
			if(correctnessStatus == REGISTRATION_CORRECTNESS_FULL)
				$("#registerForm").submit();
			else
				return;
		});
		
		$("#name").on("change",function(){
			var name = $("#name").val();
			if(isNameOrSurnameCorrect(name)){
				correctnessStatus = setFlag(correctnessStatus,NAME_CORRECT_BIT);
				showCorrect("name");
			}
			else{
				correctnessStatus = clearFlag(correctnessStatus, NAME_CORRECT_BIT);
				showError("name",NAME_ERROR);
			}
		});
		
		$("#surname").on("change",function(){
			var name = $("#surname").val();
			if(isNameOrSurnameCorrect(name)){
				correctnessStatus = setFlag(correctnessStatus,SURNAME_CORRECT_BIT);
				showCorrect("surname");
			}
			else{
				correctnessStatus = clearFlag(correctnessStatus, SURNAME_CORRECT_BIT);
				showError("surname",NAME_ERROR);
			}
		});
		
		$("#email").on("change",function(){
			var name = $("#email").val();
			if(isEmailCorrect(name)){
				correctnessStatus = setFlag(correctnessStatus,EMAIL_CORRECT_BIT);
				showCorrect("email");
			}
			else{
				correctnessStatus = clearFlag(correctnessStatus, EMAIL_CORRECT_BIT);
				showError("email",EMAIL_ERROR);
			}
		});
		
		$("#phoneNumber").on("change",function(){
			var name = $("#phoneNumber").val();
			if(isIndexNumberCorrect(name)){
				correctnessStatus = setFlag(correctnessStatus,INDEX_CORRECT_BIT);
				showCorrect("phoneNumber");
			}
			else{
				correctnessStatus = clearFlag(correctnessStatus, INDEX_CORRECT_BIT);
				showError("phoneNumber",INDEX_ERROR);
			}
		});
	})
	
	function notifyRegistration(){
		//alert(correctnessStatus);
		console.log(correctnessStatus);
		if(isRegisterDetailsCorrect())
			$("#user-details").show(1000);
		else
			$("#user-details").hide(1000);
	}
	
	function resetPasswordsFlagsAndClearRePassword(status){
		status = clearFlag(status,PASSWORD_CORRECT_BIT);
		status = clearFlag(status,SAME_PASSWORD_BIT);
		resetRePasswordErrorSpan();
		return status;
	}
	
	function resetRePasswordErrorSpan(){
		$("#re-password").val("");
		$("#re-password").css("border-color","gray");
		$("#re-password-error").html("");
		$("#re-password-error").removeClass("error-span");
	}
	
	function showError(elementID,message){
		$("#"+elementID+"-error").html(message);
		$("#"+elementID+"-error").addClass("error-span");
		$("#"+elementID).css("border-color","red");
	}
	
	function showCorrect(elementID){
		$("#"+elementID).css("border-color","green");
		$("#"+elementID+"-error").removeClass("error-span");
		$("#"+elementID+"-error").html("");
	}
	
	function isIndexNumberCorrect(indexNumber){
		var regex = /^\d{9}$/;
		return regex.test(indexNumber);		
	}
	
	function isNameOrSurnameCorrect(name){
		var regex= /^([a-zA-Z-]{2,30})(\s[a-zA-Z-]{2,15}){0,2}$/;
		return regex.test(name);
	}
	
	function isEmailCorrect(email) {
		  var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
		  return regex.test(email);
	}
	
	function isPasswordCorrect(password){
		var regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z0-9]{8,24}$/; 
		return regex.test(password);
	}
	
	function isLoginCorrect(login){
		var regex = /^([\w]{6,30})$/; 
		return regex.test(login);
	}
	
	function isRegisterDetailsCorrect(){
		return isFlagOn(correctnessStatus, LOGIN_CORRECT_BIT) && isFlagOn(correctnessStatus, PASSWORD_CORRECT_BIT)
		&& isFlagOn(correctnessStatus, SAME_PASSWORD_BIT);
	}
	
	function setFlag(num,flag){
		return bit_set(num,flag);
	}
	
	function clearFlag(num,flag){
		return bit_clear(num,flag);
	}
	
	function isFlagOn(num,flag){
		return is_bit_set(num,flag);
	}
	
</script>
<title>Registration</title>
</head>
<body>
	<c:url value="/tutorials/register"
		var="registerAction" />
	<div>
		<h1>Registration</h1>
		<form:form id="registerForm" action="${registerAction}" method="POST"
			modelAttribute="account" class="pure-form pure-form-aligned">
			<div id="account-info" class="account-info-div">
				<fieldset>
					<legend>Registration details</legend>
					<div class="pure-control-group">
						<label for="name">Login</label>
						<form:input path="login" id="login"/>
						<span id="login-error"></span>
					</div>
					<div class="pure-control-group">
						<label for="name">Password</label>
						<input type="password"
						name="password" id="password" />
						<span id="password-error"></span>
					</div>
					<div class="pure-control-group">
						<label for="name">Re-password</label>
						<input type="password"
						name="re-password" id="re-password" />
						<span id="re-password-error"></span>
					</div>
				</fieldset>
			</div>
			<div id="user-details" class="user-details-div">
				<fieldset>
					<legend>User details</legend>
					<div class="pure-control-group">
						<label for="name">Name</label>
						<form:input path="name" id="name"/>
					</div>
					<div class="pure-control-group">
						<label>Surname</label>
						<form:input path="surname" />
					</div>
					<div class="pure-control-group">
						<label>Email</label>
						<form:input path="email" />
					</div>	
					<div class="pure-control-group">
						<label>Mobile number</label>
						<form:input
							path="phoneNumber" />
					</div>
				</fieldset>
			</div>
		</form:form>
		<button class="pure-button pure-button-primary" id="submit-button">Submit</button>
	</div>	
</body>
</html>