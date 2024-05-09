-- Test chức năng đăng ký thành viên cho công ty và đăng nhập
EXEC RegisterCompany 'Công ty cổ phần BKAV', '0101360697', 'Nguyễn Tử Quảng', 'Tầng 2, tòa nhà HH1-khu đô thị Yên Hòa, Phường Yên Hoà, Quận Cầu Giấy, Thành phố Hà Nội, Việt Nam', 'bkav@example.com';
EXEC CreateAccountForCompany 'bkav', '1230123', 'Công ty cổ phần BKAV', '0101360697';
EXEC LoginUser 'bkav', '1230123';