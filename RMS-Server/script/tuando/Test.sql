--test
--Luu thong tin tuyen dung
EXEC SaveJobPostingInfo 'Trưởng dự án', 1, 3, '2024-05-20', '2024-05-23', 'Biết java', 1, '(1,2)';
EXEC SaveJobPostingInfo 'Trưởng nhóm', 1, 3, '2024-05-20', '2024-05-23', 'Biết java', 1, '(1,2,3)';
--Cap nhat thong tin tuyen dung
EXEC JobPostingReview 1, 1;
EXEC JobPostingReview 1, 0, 'haha';
EXEC JobPostingReview 2, 1;

--Lay chi tiet thong tin tuyen dung
EXEC GetJobPostingDetails 1;
select * from JobPosting;
select * from DetailJobPostingMethod;
