// Part 1 - 3
final List<String> manageGroup1 = [
  'การบำรุงรักษา/ปรับปรุงพื้นที่',
  'ทำความสะอาดร่างกาย/เสื้อผ้า',
  'ใช้อุปกรณ์ป้องกันอันตรายส่วนบุคคล',
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

// Questions
// Part 1
final Map<String, dynamic> questions1 = {
  "1.1": "มีการสัมผัสความร้อน",
  "1.2": "มีการสัมผัสเสียงดัง",
  "1.3": "มีแสงสว่างจ้าเกินไป",
  "1.4": "มีแสงสว่างไม่เพียงพอ",
  "1.5": "มีความสั่นสะเทือน",
  "1.6": "มีการสัมผัสรังสี UV",
};

// Part 2
final Map<String, dynamic> questions2 = {
  "2.1": "มีการสัมผัสฝุ่น",
  "2.2": "มีการสัมผัสสารเคมี (กรด)",
  "2.3": "มีการสัมผัสสารเคมี (ด่าง)",
  "2.4": "มีการสัมผัสสารเคมี (ไอระเหย)",
  "2.5": "มีการสัมผัสสารไวไฟ/วัตถุระเบิด",
};

// Part 3
final Map<String, dynamic> questions3 = {
  "3.1": "มีการสัมผัสแบคทีเรีย",
  "3.2": "มีการสัมผัสเชืี้อรา",
  "3.3": "มีการสัมผัสไวรัส",
};

// Part 4
final Map<String, dynamic> questions4 = {
  "4.1": "ออกแรงยกวัสดุ/สิ่งของที่มีน้ำหนักมาก",
  "4.2": "ออกแรงยกของด้วยท่าบิดเบี้ยวตัว",
  "4.3": "มีการก้มหรือเงยศรีษะ",
  "4.4":
      "ท่าทางหรือการเคลื่อนไหวที่ฝืนธรรมชาติ (เอื้อม/ที่ทำทงานสูง/ต่ำเกินไป)",
  "4.5": "ยืนหรือนั่งทำงานอยู่กับที่ติดต่อกันมากกว่า 2 ชั่วโมง",
  "4.6": "มีรูปแบบการทำงานซ้ำ ๆ",
  "4.7": "การใช้แรงดึงหรือดันที่ต้องออกแรงมากเพื่อเคลื่อนย้ายสิ่งของ",
  "4.8": "การใช้วัสดุอุปกรณ์ที่ไม่เหมาะสมกับการหยิบหรือจับ",
};

// Part 5
final Map<String, dynamic> questions5 = {
  "5.1": "ทำงานอย่างเร่งเรียบ",
  "5.2": "งานมีความยุ่งยากและซับซ้อน",
  "5.3": "ขัดแย้งกับเพื่อนร่วมงานหรือหัวหน้าหรือนายจ้าง",
  "5.4": "งานมีความเครียด/กดดัน",
};

// Part 6
final Map<String, dynamic> questions6_1 = {
  "6.1": "การใช้อุปกรณ์หรือเครื่องมือที่แหลมคม",
  "6.2": "การใช้อุปกรณ์หรือเครื่องมือที่ชำรุด/แตก/หัก/ร้าว",
  "6.3": "การใช้เครื่องจักรกล",
  "6.4": "การใช้ยานพาหนะ",
  "6.5": "การทำงานที่สูง มากกว่า 2 เมตร",
  "6.6": "การทำงานในที่คับแคบ",
  "6.7": "สภาพพื้นที่ทำงานลื่น",
  "6.8": "การทำงานกับสิ่งของร้อน",
  "6.9": "มีสิ่งกีดขวางทางเดิน",
  "6.10": "การทำงานหลังจากกินยาที่ทำให้เกิดอาการง่วงนอน เช่น ยาแก้แพ้",
  "6.11": "การทำงานในขณะที่ร่างกายอ่อนเพลีย",
  "6.12": "การทำงานกับไฟฟ้า",
};
final Map<String, dynamic> questions6_2 = {
  "6.13": "วัสดุสิ่งของตัด/บาด/ทิ่ม/แทง",
  "6.14": "วัสดุสิ่งของพังทลาย/หล่นทับ",
  "6.15": "วัสดุสิ่งของกระแทก/ชน",
  "6.16": "วัสดุสิ่งของ/สารเคมีกระเด็นเข้าตา",
  "6.17": "วัสดุสิ่งของหนีบ/ดึง",
};

// Part 7
final Map<String, dynamic> questions7 = {
  "7.1": "การใช้อุปกรณ์หรือเครื่องมือไฟฟ้า",
  "7.2": "การเก็บวัตถุไวไฟ เช่น ถังแก๊ส",
  "7.3": "การใช้สารเคมีหรือก๊าซติดไฟง่าย",
};
// Part 8
final Map<String, dynamic> questions8 = {
  "8.1": "มีความรู้สึกแออัด หรืออึดอัด",
  "8.2": "อากาศร้อนเกินไป",
  "8.3": "อากาศหนาวเกินไป",
  "8.4": "มีกลิ่นฉุนของสารเคมี",
  "8.5": "รบบระบายอากาศไม่ดี",
  "8.6": "อับทึบหรือชื้นเกินไป",
};

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
