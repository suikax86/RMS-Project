use RMS
exec p_getCVList 'Dang xu ly'
exec p_getCVList NULL

exec p_process_cv 1, 'Da xu ly'
exec p_process_cv 2, 'Khong du dieu kien'
exec p_process_cv 9, 'Khong du dieu kien'

exec p_getcvlist_company 2
exec p_getcvlist_company 4

exec p_update_status 1, 'Da phan hoi', 'asdasd'
exec p_update_status 9, 'Da phan hoi', 'asdasd'

exec p_getcv_description 1, 0
exec p_getcv_description 1, 1
exec p_getcv_description 9, 1

exec p_getapproved_company 1
exec p_getapproved_company 9

