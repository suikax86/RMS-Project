-- Insert value for Employee
INSERT INTO Employees(EmployeeName, Address, DOB, Email, Phone)
VALUES (N'Nguyễn Văn A', N'123 Đường ABC, Quận 1, TP.HCM', '1999-01-01','example@email.com', '0123456789');

-- Insert value for PostForm
INSERT INTO PostForm(CompanyID, Position, Quantity, StartTime, EndTime, Requirements)
VALUES (1, N'C++ Developer', 5, '2024-05-05', '2024-07-31', N'Kinh nghiệm 1 năm');

-- Insert value for JobPosting
INSERT INTO JobPosting(NV_ID, PostTime, PostingMethod, PostFormID, PostStatus)
VALUES (1, '2024-05-05', N'Online', 1, N'Đang tuyển dụng');