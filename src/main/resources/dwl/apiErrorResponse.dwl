%dw 2.0
output application/json
---
{
	(if ( !isEmpty(error.errorMessage.payload.webserviceControllerOutput) ) {
		webserviceControllerOutput: error.errorMessage.payload.webserviceControllerOutput
	} else {
		"webserviceControllerOutput": {
			'severity': 'error',
			'code': attributes.httpStatus,
			'status': error.detailedDescription,
			details: error.errorMessage.payload
		}
	})
}