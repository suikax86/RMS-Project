-- Companies
EXEC RegisterCompany N'Công ty cổ phần BKAV', '0101360697', N'Nguyễn Tử Quảng', N'Tầng 2, tòa nhà HH1-khu đô thị Yên Hòa, Phường Yên Hoà, Quận Cầu Giấy, Thành phố Hà Nội, Việt Nam', 'bkav@example.com';

-- JobPosting
EXEC SaveJobPostingInfo N'C++ Developer', 5, 3, '2024-05-20', '2024-05-23', 'Knowledge about embedded system, Realtime OS, and Linux', 1, '(1,2)';
EXEC SaveJobPostingInfo N'Java Backend Developer', 3, 14, '2024-06-01', '2024-06-15', 'Strong understanding of Java, Spring Boot, and microservices architecture', 1, '(2,3)';
EXEC SaveJobPostingInfo N'Frontend Developer', 4, 14, '2024-07-10', '2024-07-24', 'Proficient in JavaScript, React, and responsive design principles', 1, '(3,1)';
EXEC SaveJobPostingInfo N'Full Stack Developer', 2, 14, '2024-08-05', '2024-08-19', 'Experience with both frontend and backend technologies, including Node.js and Angular', 1, '(1,3)';
EXEC SaveJobPostingInfo N'Data Scientist', 2, 15, '2024-09-15', '2024-09-30', 'Expertise in Python, machine learning algorithms, and data visualization tools', 1, '(2,1)';


EXEC JobPostingReview 1, 1;

EXEC GetJobPostingDetails 1;
