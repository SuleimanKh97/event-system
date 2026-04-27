-- Campus Event System - Extended Sample Data
-- Make sure you've already imported the database schema from campus_event_db.sql first!
-- All user passwords are set to '1234' for easy testing.

-- ==========================================
-- 1. EXTENDED USERS (2 Admins, 5 Organizers, 15 Students)
-- ==========================================
INSERT IGNORE INTO `users` (`id`, `full_name`, `email`, `password`, `role`, `faculty`, `department`, `admission_year`, `blocked`) VALUES
-- Admins
(100, 'Admin Super', 'admin@campus.edu', '1234', 'admin', 'Administration', 'IT Services', 2020, 0),
(101, 'Admin Tech', 'support@campus.edu', '1234', 'admin', 'Administration', 'SysAdmin', 2018, 0),

-- Organizers
(102, 'Dr. Sarah Organizer', 'sarah@campus.edu', '1234', 'organizer', 'Science', 'Computer Science', 2018, 0),
(103, 'Coach Mike', 'mike.sports@campus.edu', '1234', 'organizer', 'Physical Education', 'Athletics', 2015, 0),
(104, 'Prof. Robert Literature', 'robert@campus.edu', '1234', 'organizer', 'Arts', 'Literature', 2012, 0),
(105, 'Eng. Khaled', 'khaled@campus.edu', '1234', 'organizer', 'Engineering', 'Mechanical Engineering', 2019, 0),
(106, 'Dr. Mona Business', 'mona@campus.edu', '1234', 'organizer', 'Business', 'Finance', 2020, 0),

-- Students
(107, 'John Doe', 'john@student.edu', '1234', 'student', 'Engineering', 'Mechanical', 2024, 0),
(108, 'Emma Watson', 'emma@student.edu', '1234', 'student', 'Arts', 'Literature', 2025, 0),
(109, 'Ali Student', 'ali@student.edu', '1234', 'student', 'Business', 'Marketing', 2023, 0),
(110, 'Fatima Noor', 'fatima@student.edu', '1234', 'student', 'Science', 'Computer Science', 2024, 0),
(111, 'Omar Hassan', 'omar@student.edu', '1234', 'student', 'Science', 'Information Technology', 2026, 0),
(112, 'Sophia Lee', 'sophia@student.edu', '1234', 'student', 'Engineering', 'Electrical', 2025, 0),
(113, 'James Smith', 'james@student.edu', '1234', 'student', 'Arts', 'History', 2023, 0),
(114, 'Nour Al-Sabah', 'nour@student.edu', '1234', 'student', 'Business', 'Accounting', 2022, 0),
(115, 'Liam Nelson', 'liam@student.edu', '1234', 'student', 'Physical Education', 'Sports Science', 2025, 0),
(116, 'Youssef Ahmed', 'youssef@student.edu', '1234', 'student', 'Engineering', 'Civil', 2024, 0),
(117, 'Layla Tariq', 'layla@student.edu', '1234', 'student', 'Science', 'Chemistry', 2026, 0),
(118, 'Isabella Rossi', 'isabella@student.edu', '1234', 'student', 'Arts', 'Languages', 2024, 0),
(119, 'Zayn Malik', 'zayn@student.edu', '1234', 'student', 'Business', 'Management', 2023, 0),
(120, 'Amira Khalid', 'amira@student.edu', '1234', 'student', 'Science', 'Physics', 2025, 0),
(121, 'Ethan Wright', 'ethan@student.edu', '1234', 'student', 'Engineering', 'Computer Engineering', 2026, 0);


-- ==========================================
-- 2. EXTENDED EVENTS (20 total, various types/statuses)
-- ==========================================
INSERT IGNORE INTO `events` (`id`, `title`, `description`, `event_date`, `capacity`, `type`, `organizer_id`, `organizer_name`, `department_club`, `event_time`, `location`, `category`, `image_path`, `registration_status`, `event_status`) VALUES

-- UPCOMING OPEN EVENTS
(200, 'Intro to Artificial Intelligence', 'Basics of AI and Machine Learning using Python.', '2026-10-15', 38, 'Workshop', 102, 'Dr. Sarah Organizer', 'Computer Science Dept', '14:00:00', 'Building A - Room 101', 'Educational', NULL, 'OPEN', 'UPCOMING'),
(201, 'Annual Spring Tech Seminar', 'Guest speakers from top tech companies.', '2026-11-05', 90, 'Seminar', 102, 'Dr. Sarah Organizer', 'Engineering Club', '10:00:00', 'Main Auditorium', 'Technical', NULL, 'OPEN', 'UPCOMING'),
(202, 'Campus Marathon 2026', '5K run around the campus. Free t-shirts!', '2026-12-01', 195, 'Sports Activity', 103, 'Coach Mike', 'Athletics Dept', '08:00:00', 'Campus Stadium', 'Sports', NULL, 'OPEN', 'UPCOMING'),
(203, 'Late Night Board Games', 'Relax before midterms with pizza and games.', '2026-09-30', 10, 'Club Social Event', 102, 'Board Game Club', 'Student Union', '19:00:00', 'Student Center Cafe', 'Social', NULL, 'OPEN', 'UPCOMING'),
(204, 'Creative Writing Workshop', 'Unlock your inner novelist. Bring a notebook.', '2026-11-12', 20, 'Workshop', 104, 'Prof. Robert Literature', 'Creative Writing Society', '15:30:00', 'Library Wing C', 'Cultural', NULL, 'OPEN', 'UPCOMING'),
(205, 'Robotics Demo Day', 'Watch autonomous drones and rovers in action.', '2026-10-25', 150, 'Seminar', 105, 'Eng. Khaled', 'Robotics Club', '11:00:00', 'Engineering Quad', 'Technical', NULL, 'OPEN', 'UPCOMING'),
(206, 'Start-up Pitch Night', 'Students pitch business ideas for actual seed funding.', '2026-11-20', 55, 'Club Social Event', 106, 'Dr. Mona Business', 'Entrepreneurs Club', '18:00:00', 'Business School Atrium', 'Educational', NULL, 'OPEN', 'UPCOMING'),
(207, 'Inter-departmental Football Tournament', 'Departments face off in a 7v7 knockout tournament.', '2026-10-10', 0, 'Sports Activity', 103, 'Coach Mike', 'Athletics Dept', '16:00:00', 'Main Field', 'Sports', NULL, 'OPEN', 'UPCOMING'), -- Fully booked!

-- UPCOMING CLOSED EVENTS (Registration closed manually by organizer)
(208, 'Advanced Cryptography Seminar', 'Deep dive into hashing and encryption standards.', '2026-11-15', 50, 'Seminar', 102, 'Dr. Sarah Organizer', 'Cybersecurity Club', '13:00:00', 'Lab 2', 'Technical', NULL, 'CLOSED', 'UPCOMING'),
(209, 'Leadership Retreat Phase 1', 'Invited students only.', '2026-10-05', 25, 'Workshop', 106, 'Dr. Mona Business', 'Student Council', '09:00:00', 'Off-campus Hotel', 'Social', NULL, 'CLOSED', 'UPCOMING'),

-- PAST COMPLETED EVENTS (Ready for rating)
(210, 'Basics of Web Dev (HTML/CSS)', 'Beginner web development.', '2025-01-10', 30, 'Workshop', 102, 'Dr. Sarah Organizer', 'Computer Science Dept', '13:00:00', 'Lab 4', 'Educational', NULL, 'CLOSED', 'COMPLETED'),
(211, 'Shakespeare Analysis', 'Reading and breakdown of Hamlet.', '2025-03-22', 40, 'Seminar', 104, 'Prof. Robert Literature', 'Literature Dept', '14:00:00', 'Room 305', 'Cultural', NULL, 'CLOSED', 'COMPLETED'),
(212, 'Winter Basketball Classic', 'Friendly 3v3 matches.', '2025-12-15', 100, 'Sports Activity', 103, 'Coach Mike', 'Basketball Club', '17:00:00', 'Indoor Gym', 'Sports', NULL, 'CLOSED', 'COMPLETED'),
(213, 'Stock Market Bootcamp', 'Learn how to trade safely.', '2026-02-14', 60, 'Workshop', 106, 'Dr. Mona Business', 'Finance Society', '10:00:00', 'Business Room 102', 'Educational', NULL, 'CLOSED', 'COMPLETED'),

-- EXPIRED EVENTS (Date passed, but organizer never marked them complete)
(214, 'Poetry Slam Night 2025', 'Open mic night.', '2025-11-20', 50, 'Club Social Event', 104, 'Prof. Robert', 'Arts Club', '20:00:00', 'Cafeteria', 'Cultural', NULL, 'CLOSED', 'EXPIRED'),
(215, 'AutoCAD Workshop', 'For civil and mechanical engineers.', '2026-01-05', 25, 'Workshop', 105, 'Eng. Khaled', 'Engineering Society', '09:00:00', 'Lab 1', 'Technical', NULL, 'CLOSED', 'EXPIRED');


-- ==========================================
-- 3. EXTENDED RESERVATIONS
-- ==========================================
INSERT IGNORE INTO `reservations` (`id`, `user_id`, `event_id`, `status`, `attendance_status`) VALUES

-- AI Workshop (200) Attendees
(301, 107, 200, 'RESERVED', 'ABSENT'),
(302, 108, 200, 'RESERVED', 'ABSENT'),
(303, 110, 200, 'RESERVED', 'ABSENT'),
(304, 111, 200, 'RESERVED', 'ABSENT'),
(305, 121, 200, 'RESERVED', 'ABSENT'),

-- Spring Tech Seminar (201)
(306, 112, 201, 'RESERVED', 'ABSENT'),
(307, 116, 201, 'RESERVED', 'ABSENT'),
(308, 121, 201, 'RESERVED', 'ABSENT'),
(309, 107, 201, 'RESERVED', 'ABSENT'),

-- Marathon (202)
(310, 107, 202, 'RESERVED', 'ABSENT'),
(311, 109, 202, 'RESERVED', 'ABSENT'),
(312, 115, 202, 'RESERVED', 'ABSENT'),
(313, 119, 202, 'RESERVED', 'ABSENT'),
(314, 120, 202, 'RESERVED', 'ABSENT'),

-- Board Games (203)
(315, 108, 203, 'RESERVED', 'ABSENT'),
(316, 110, 203, 'RESERVED', 'ABSENT'),
(317, 113, 203, 'RESERVED', 'ABSENT'),
(318, 117, 203, 'RESERVED', 'ABSENT'),
(319, 118, 203, 'RESERVED', 'ABSENT'),

-- Start-up Pitch Night (206)
(320, 109, 206, 'RESERVED', 'ABSENT'),
(321, 114, 206, 'RESERVED', 'ABSENT'),
(322, 119, 206, 'RESERVED', 'ABSENT'),

-- PAST EVENT: Web Dev (210) (Attendance logged)
(323, 107, 210, 'RESERVED', 'PRESENT'),
(324, 109, 210, 'RESERVED', 'PRESENT'),
(325, 110, 210, 'RESERVED', 'ABSENT'),
(326, 121, 210, 'RESERVED', 'PRESENT'),

-- PAST EVENT: Shakespeare (211)
(327, 108, 211, 'RESERVED', 'PRESENT'),
(328, 113, 211, 'RESERVED', 'PRESENT'),
(329, 118, 211, 'RESERVED', 'PRESENT'),

-- PAST EVENT: Winter Basketball (212)
(330, 107, 212, 'RESERVED', 'PRESENT'),
(331, 115, 212, 'RESERVED', 'PRESENT'),
(332, 116, 212, 'RESERVED', 'PRESENT'),
(333, 119, 212, 'RESERVED', 'ABSENT'),

-- PAST EVENT: Stock Market Bootcamp (213)
(334, 109, 213, 'RESERVED', 'PRESENT'),
(335, 114, 213, 'RESERVED', 'PRESENT');


-- ==========================================
-- 4. EXTENDED RATINGS 
-- Only allowed to rate COMPLETED or EXPIRED events reserved by the student.
-- ==========================================
INSERT IGNORE INTO `ratings` (`id`, `user_id`, `event_id`, `rating`, `comment`) VALUES
-- Web Dev ratings
(401, 107, 210, 5, 'Highly recommend for complete beginners!'),
(402, 109, 210, 4, 'Good pace, but the room was a bit cold.'),
(403, 121, 210, 5, 'Dr. Sarah explained CSS layout perfectly.'),

-- Shakespeare ratings
(404, 108, 211, 4, 'Very insightful analysis.'),
(405, 118, 211, 5, 'Loved the dramatic readings we did.'),

-- Basketball ratings
(406, 107, 212, 5, 'Great energy and perfectly organized bracket.'),
(407, 115, 212, 3, 'My team lost in the first round :('),
(408, 116, 212, 4, 'Solid refs and good courts.'),

-- Stock Market Bootcamp
(409, 109, 213, 5, 'Paid for itself instantly in knowledge!'),
(410, 114, 213, 5, 'Fantastic introduction to fundamental analysis.');
