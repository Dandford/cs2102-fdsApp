DROP TABLE IF EXISTS Users CASCADE; 
DROP TABLE IF EXISTS Restaurants CASCADE;
DROP TABLE IF EXISTS Menus CASCADE;
DROP TABLE IF EXISTS FoodItems CASCADE;
DROP TABLE IF EXISTS RestaurantStaffs CASCADE;
DROP TABLE IF EXISTS Customers CASCADE;
DROP TABLE IF EXISTS Customers_address CASCADE;
DROP TABLE IF EXISTS FdsManagers CASCADE;
DROP TABLE IF EXISTS Riders CASCADE;
DROP TABLE IF EXISTS Orders CASCADE;
DROP TABLE IF EXISTS Deliveries CASCADE;
DROP TABLE IF EXISTS Promotions CASCADE;
DROP TABLE IF EXISTS Coupons CASCADE;
DROP TABLE IF EXISTS Wws CASCADE;
DROP TABLE IF EXISTS Mws CASCADE;

CREATE TABLE Restaurants {
    res_id           VARCHAR(255) PRIMARY KEY,
    address       VARCHAR(255) NOT NULL,
    rname         VARCHAR(255) NOT NULL,
    min_amout     INTEGER NOT NULL
};

CREATE TABLE Menuitems {
    res_id    VARCHAR(255),
    food_id   VARCHAR(255),
    price     NUMERIC,
    PRIMARY KEY(res_id, food_id),
    FOREIGN KEY (res_id) REFERENCES Restaurants,
    FOREIGN KEY (food_id) REFERENCES FoodItems DELETE ON CASCADE
};

CREATE TABLE FoodItems {
    food_id            TEXT PRIMARY KEY,
    name               TEXT,
    desc               TEXT, 
    imagepath          VARCHAR(255)
};


CREATE TABLE Users (
    usr_id               VARCHAR(255) PRIMARY KEY,
    userName             VARCHAR(255) NOT NULL,
    password_digest      VARCHAR(255) NOT NULL,
    isFdsManager         BOOLEAN DEFAULT FALSE
);

CREATE TABLE RestaurantStaffs {
    usr_id         VARCHAR(255) NOT NULL,
    res_id         VARCHAR(255) NOT NULL,
    PRIMARY KEY(usr_id),
    FOREIGN KEY (usr_id) REFERENCES Users,
    FOREIGN KEY (res_id) REFERENCES Restaurants
};

CREATE TABLE Customers {
    usr_id               VARCHAR(255) NOT NULL,
    card_num             INTEGER(16),
    last_order_time      TIMESTAMP DEFAULT NULL,
    PRIMARY KEY(usr_id),
    FOREIGN KEY (usr_id) REFERENCES Users
};

--Keep track of customers recent address at most 5 per customer
--If the address is alr in the table, update the time,
--display of address based on the last use time
--on update, delete the olders address and add the new address
CREATE TABLE Customers_address {
    usr_id          VARCHAR(255) NOT NULL,
    address         TEXT NOT NULL,
    last_use_time   TIMESTAMP NOT NULL,
    PRIMARY KEY(usr_id, address),
    FOREIGN KEY (usr_id) REFERENCES Customers
};

CREATE TABLE Riders {
    usr_id        VARCHAR(255) NOT NULL PRIMARY KEY,
    FOREIGN KEY (usr_id) REFERENCES Users
};

CREATE TABLE Fulltimerider {
    usr_id         VARCHAR(255) NOT NULL PRIMARY KEY,
    base_salary    NUMERIC NOT NULL,
    FOREIGN KEY (usr_id) REFERENCES Riders
};

CREATE TABLE Parttimerider {
    usr_id         VARCHAR(255) NOT NULL PRIMARY KEY,
    base_salary    NUMERIC NOT NULL,
    FOREIGN KEY (usr_id) REFERENCES Riders
};

CREATE TABLE Orders {
    order_id       VARCHAR(255) PRIMARY KEY,
    usr_id         VARCHAR(255) NOT NULL,
    res_id         VARCHAR(255) NOT NULL,
    isCheckedOut   BOOLEAN,
    payment        VARCHAR(255) NOT NULL 
                                CHECK (payment in ("card", "cash")),
    listOfItems    OrderItem[] NOT NULL,
    status         VARCHAR(20) NOT NULL 
                             CHECK (status in("pending", "in progress", "complete")),
    FOREIGN KEY(usr_id) REFERENCES Customers,
    FOREIGN KEY(res_id) REFERENCES Restaurants
};

CREATE TYPE OrderItem AS (
    food_id     TEXT,
    qty        INTEGER
);

CREATE TABLE Deliveries {
    order_id         VARCHAR(255) PRIMARY KEY,
    place_order_time  TIMESTAMP NOT NULL,
    dr_leave_for_res  TIMESTAMP,
    dr_arrive_res     TIMESTAMP,
    dr_leave_res      TIMESTAMP,
    dr_arrive_cus     TIMESTAMP,
    FOREIGN KEY(order_id) REFERENCES Orders,
    FOREIGN KEY(usr_id) REFERENCES Riders
};

CREATE TABLE Promotions {
    pid        VARCHAR(255) PRIMARY KEY,
    type       VARCHAR(255) NOT NULL
                            CHECK(type in("FDS", "RES")),
    desc       TEXT NOT NULL,
    start_day  TIMESTAMP NOT NULL,
    end_day    TIMESTAMP NOT NULL
};


CREATE TABLE Coupons {
    coupon_id      VARCHAR(255) PRIMARY KEY,
    usr_id         VARCHAR(255),
    desc            VARCHAR(255) NOT NULL,
    expiry_date     TIMESTAMP,
    FOREIGN KEY (usr_id) REFERENCES Customers
};

--need to check
CREATE TABLE Wws {
    usr_id       VARCHAR(255) NOT NULL,
    day          INTEGER(2) NOT NULL,
    month        INTEGER(2) NOT NULL,
    year         INTEGER(4) NOT NULL,
    start_time   TIMESTAMP NOT NULL,
    end_time     TIMESTAMP NOT NULL,
    PRIMARY KEY(usr_id, day, month, year, start_time, end_time),
    FOREIGN KEY(usr_id) REFERENCES Parttimerider
};

--for full time rider
CREATE TABLE Shifts {
    shift_id    INTEGER(1) PRIMARY KEY,
    start_time1 TIMESTAMP NOT NULL,
    start_time2 TIMESTAMP NOT NULL,
    end_time1   TIMESTAMP NOT NULL,
    end_time2   TIMESTAMP NOT NULL
};

--need to check
CREATE TABLE Mws {
    usr_id       VARCHAR(255) NOT NULL,
    day          INTEGER(2) NOT NULL,
    month        INTEGER(2) NOT NULL,
    year         INTEGER(4) NOT NULL,
    shift_id     INTEGER(1) NOT NULL,
    PRIMARY KEY(usr_id, day, month, year),
    FOREIGN KEY(shift_id) REFERENCES Shifts,
    FOREIGN KEY(usr_id) REFERENCES Fulltimerider

};
