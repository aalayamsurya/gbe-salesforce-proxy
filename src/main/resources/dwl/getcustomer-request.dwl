%dw 2.0
output application/json
---
{
 "ID_ACCT" : attributes.queryParams.ng_crisrefid,
 "ID_USER" : attributes.queryParams.ng_cris_userid,
 "TRANSACTION_ID" : attributes.headers.ng_tid,
}


