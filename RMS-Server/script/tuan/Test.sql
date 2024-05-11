use RMS
exec p_getCVList

exec p_set_status 1, 'sent'
exec p_set_status 2, 'sent'

exec p_get_req_des 1, 0
exec p_get_req_des 1, 1
exec p_get_req_des 2, 0