-- [A. Quy trinh dang ky thanh vien ]Test chức năng đăng ký thành viên cho công ty và đăng nhập
EXEC RegisterCompany N'Công ty cổ phần BKAV', '0101360697', N'Nguyễn Tử Quảng', N'Tầng 2, tòa nhà HH1-khu đô thị Yên Hòa, Phường Yên Hoà, Quận Cầu Giấy, Thành phố Hà Nội, Việt Nam', 'bkav@example.com';
EXEC CreateAccountForCompany 'bkav', '1230123', N'Công ty cổ phần BKAV', '0101360697';
EXEC LoginUser 'bkav', '1230123';

-- [C. Quy trinh nop ho so tuyen dung]
