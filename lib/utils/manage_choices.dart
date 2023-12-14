// Part 1 - 3
final List<String> manageGroup1 = [
  'การบำรุงรักษา/ปรับปรุงพื้นที่',
  'ทำความสะอาดร่างกาย/เสื้อผ้า',
  'ใช้อุปกร์ป้องกันอันตรายส่วนบุคคล',
  'เรียนรู้/อ่านฉลาก/คู่มือ',
  'ตรวจสุขภาพ',
];

//Part 4 - 5
final List<String> manageGroup2 = [
  'ใช้อุปกรณ์ช่วยทำงาน (ยก/หยิบจับ)',
  'บริหารร่างกาย/ออกกำลังกาย',
  'ปรับพฤติกรรมในการทำงาน',
  'ปรับท่าทางการทำงาน',
  'มีกิจกรรมผ่อนคลาย',
];

//Part 6 - 8
final List<String> manageGroup3 = [
  'ทำความสะอาดจัดระเบียบพื้นที่ทำงาน',
  'การบำรุงรักษา/ปรับปรุงสภาพพื้นที่',
  'ใช้อุปกรณ์ป้องกันอันตราย',
  'เรียนรู้/อ่านฉลาก/คู่มือ',
  'พักผ่อนอย่างเพียงพอ',
];

// Part 1
final Map<String, dynamic> manageChoice1 = {
  "1.1": [false, false, false, false, false],
  "1.2": [false, false, false, false, false],
  "1.3": [false, false, false, false, false],
  "1.4": [false, false, false, false, false],
  "1.5": [false, false, false, false, false],
  "1.6": [false, false, false, false, false],
};

final Map<String, dynamic> enableManage1 = {
  "1.1": [false, false, true, true, true],
  "1.2": [true, false, true, true, true],
  "1.3": [true, false, true, true, true],
  "1.4": [true, false, true, true, true],
  "1.5": [true, false, true, true, true],
  "1.6": [true, true, true, true, true],
};

// Part 2
final Map<String, dynamic> manageChoice2 = {
  "2.1": [false, false, false, false, false],
  "2.2": [false, false, false, false, false],
  "2.3": [false, false, false, false, false],
  "2.4": [false, false, false, false, false],
  "2.5": [false, false, false, false, false],
};
final Map<String, dynamic> enableManage2 = {
  "2.1": [true, true, true, true, true],
  "2.2": [true, true, true, true, true],
  "2.3": [true, true, true, true, true],
  "2.4": [true, true, true, true, true],
  "2.5": [true, false, true, true, true],
};

// Part 3
final Map<String, dynamic> manageChoice3 = {
  "3.1": [false, false, false, false, false],
  "3.2": [false, false, false, false, false],
  "3.3": [false, false, false, false, false],
};
final Map<String, dynamic> enableManage3 = {
  "3.1": [true, true, true, true, true],
  "3.2": [true, true, true, true, true],
  "3.3": [true, true, true, true, true],
};

// Part 4
final Map<String, dynamic> manageChoice4 = {
  "4.1": [false, false, false, false, false],
  "4.2": [false, false, false, false, false],
  "4.3": [false, false, false, false, false],
  "4.4": [false, false, false, false, false],
  "4.5": [false, false, false, false, false],
  "4.6": [false, false, false, false, false],
  "4.7": [false, false, false, false, false],
  "4.8": [false, false, false, false, false],
};
final Map<String, dynamic> enableManage4 = {
  "4.1": [true, true, true, true, true],
  "4.2": [true, true, true, true, true],
  "4.3": [true, true, true, true, true],
  "4.4": [true, true, true, true, true],
  "4.5": [true, true, true, true, true],
  "4.6": [true, true, true, true, true],
  "4.7": [true, true, true, true, true],
  "4.8": [true, true, true, true, true],
};

// Part 5
final Map<String, dynamic> manageChoice5 = {
  "5.1": [false, false, false, false, false],
  "5.2": [false, false, false, false, false],
  "5.3": [false, false, false, false, false],
  "5.4": [false, false, false, false, false],
};
final Map<String, dynamic> enableManage5 = {
  "5.1": [false, false, true, false, false],
  "5.2": [false, false, true, false, false],
  "5.3": [false, false, true, false, true],
  "5.4": [false, true, true, false, true],
};

// Part 6
final Map<String, dynamic> manageChoice6 = {
  "6.1": [false, false, false, false, false],
  "6.2": [false, false, false, false, false],
  "6.3": [false, false, false, false, false],
  "6.4": [false, false, false, false, false],
  "6.5": [false, false, false, false, false],
  "6.6": [false, false, false, false, false],
  "6.7": [false, false, false, false, false],
  "6.8": [false, false, false, false, false],
  "6.9": [false, false, false, false, false],
  "6.10": [false, false, false, false, false],
  "6.11": [false, false, false, false, false],
  "6.12": [false, false, false, false, false],
  "6.13": [false, false, false, false, false],
  "6.14": [false, false, false, false, false],
  "6.15": [false, false, false, false, false],
  "6.16": [false, false, false, false, false],
  "6.17": [false, false, false, false, false],
};
final Map<String, dynamic> enableManage6 = {
  "6.1": [false, true, true, true, false],
  "6.2": [false, true, true, true, false],
  "6.3": [true, true, true, true, false],
  "6.4": [true, true, true, true, true],
  "6.5": [true, true, true, true, true],
  "6.6": [true, true, true, true, true],
  "6.7": [true, true, true, true, false],
  "6.8": [false, true, true, true, false],
  "6.9": [true, true, false, true, false],
  "6.10": [false, false, false, true, true],
  "6.11": [false, false, false, true, true],
  "6.12": [true, true, true, true, false],
  "6.13": [true, true, true, true, false],
  "6.14": [true, true, true, true, false],
  "6.15": [true, true, true, true, false],
  "6.16": [true, true, true, true, false],
  "6.17": [true, true, true, true, false],
};

// Part 7
final Map<String, dynamic> manageChoice7 = {
  "7.1": [false, false, false, false, false],
  "7.2": [false, false, false, false, false],
  "7.3": [false, false, false, false, false],
};
final Map<String, dynamic> enableManage7 = {
  "7.1": [true, true, true, true, false],
  "7.2": [true, true, true, true, false],
  "7.3": [true, true, true, true, false],
};

// Part 8
final Map<String, dynamic> manageChoice8 = {
  "8.1": [false, false, false, false, false],
  "8.2": [false, false, false, false, false],
  "8.3": [false, false, false, false, false],
  "8.4": [false, false, false, false, false],
  "8.5": [false, false, false, false, false],
  "8.6": [false, false, false, false, false],
};

final Map<String, dynamic> enableManage8 = {
  "8.1": [true, true, false, true, false],
  "8.2": [true, true, true, true, false],
  "8.3": [true, true, true, true, false],
  "8.4": [true, true, true, true, false],
  "8.5": [true, true, true, true, false],
  "8.6": [true, true, true, true, false],
};
