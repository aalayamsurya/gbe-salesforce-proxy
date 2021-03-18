%dw 2.0
output text/plain
---
 "\nError Occurred - Could not process request/response" ++
"\n    " ++
"\nSource System : " ++ vars.'Source-System'    ++
"\nTarget System : " ++ vars.'Target-System'    ++
"\n    " ++
"\nCorrelationId : " ++ correlationId ++
"\n    "  ++
"\n============================================================" ++
"\nRequestPayload: " ++
"\n " ++
	(vars.requestPayload.^raw as String default "Issue with input payload") ++
"\n============================================================" ++	
"\nError Message" ++
"\n-----------------------------------------------------------------------------------" ++
"\n" ++ (payload.webserviceControllerOutput.status as String   default "Internal Error")   ++
"\n" ++ (payload.webserviceControllerOutput.details as String default "Please contact API support Team") ++
"\n    " ++
"\n============================================================" ++
"\nERROR : " ++ 
     (error.description as String default "Internal Error") ++
"\n " ++ "ErrorCode: " ++ (vars.httpStatus as String default "500") ++
"\n    "  ++
"\n                             " ++ "TimeStamp :" ++ now()