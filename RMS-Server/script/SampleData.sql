-- Companies
EXEC RegisterCompany N'Công ty cổ phần BKAV', '0101360697', N'Nguyễn Tử Quảng', N'Tầng 2, tòa nhà HH1-khu đô thị Yên Hòa, Phường Yên Hoà, Quận Cầu Giấy, Thành phố Hà Nội, Việt Nam', 'bkav@example.com';
EXEC SaveJobPostingInfo N'C++ Developer', 5, 3, '2024-05-20', '2024-05-23', 'Knowledge about embedded system, Realtime OS, and Linux', 1, '(1,2)';

EXEC JobPostingReview 1, 1;
EXEC GetJobPostingDetails 1;
