var DY = {};

DY.post = function(url, param, success, error) {
	
	$.post(url, param, function(data, status) {
			
			var ajaxDTO = data;
			
			if (!ajaxDTO.success) {
				alert(ajaxDTO.message);
				
				if ('302' == ajaxDTO.code) {
					window.location.href='/user/toLogin.do';
					return false;
				}
				
				error(ajaxDTO, status);
				
				return false;
			}
			
			success(ajaxDTO, status);
	});		
	
}