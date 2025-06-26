CREATE DATABASE accounts;
USE accounts;

-- Tạo bảng accounts
CREATE TABLE accounts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    balance DECIMAL(15,2) NOT NULL
);

-- Tạo stored procedure
DROP PROCEDURE IF EXISTS transfer_funds;
DELIMITER //

CREATE PROCEDURE transfer_funds(
    IN p_from_id INT,
    IN p_to_id INT,
    IN p_amount DECIMAL(15,2),
    OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE from_balance DECIMAL(15,2);

    -- Lấy số dư tài khoản nguồn
    SELECT balance INTO from_balance FROM accounts WHERE id = p_from_id;

    -- Kiểm tra đủ tiền
    IF from_balance < p_amount THEN
        SET p_message = 'Số dư không đủ để chuyển tiền';
    ELSE
        -- Trừ tiền người gửi
        UPDATE accounts SET balance = balance - p_amount WHERE id = p_from_id;

        -- Cộng tiền người nhận
        UPDATE accounts SET balance = balance + p_amount WHERE id = p_to_id;

        -- Gán thông báo thành công
        SET p_message = CONCAT('Đã chuyển ', p_amount, ' từ tài khoản ', p_from_id, ' sang tài khoản ', p_to_id);
    END IF;
END //

DELIMITER ;

INSERT INTO accounts(balance) VALUES (1000.00), (500.00);

