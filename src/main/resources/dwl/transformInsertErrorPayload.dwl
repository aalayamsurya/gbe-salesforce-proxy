%dw 2.0
output application/json
---
{
	'webserviceControllerOutput': {
		'severity': 'error',
		'code': payload.status,
		(if ( sizeOf (payload.errors) > 0 ) {
			'status': (payload.errors[0].errorMessage default "internal error") ++ " Contact API Management team for support",
			details: payload.errors[0].developerMessage default "internal error"
		} else {
			 'status': if(error.description == error.detailedDescription)  error.errorType['asString'] else error.description,
			details: error.detailedDescription
		})
	}
}
