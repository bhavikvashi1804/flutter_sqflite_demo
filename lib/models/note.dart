class Note {

  //data
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;

  //constructor
  Note(this._title, this._date, this._priority, [this._description]);
  //[] argument indicates optional
  Note.withId(this._id, this._title, this._date, this._priority, [this._description]);

  //getter
  int get id => _id;
  String get title => _title;
  String get description => _description;
  int get priority => _priority;
  String get date => _date;

  //setter
  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }
  set description(String newDescription) {
    if (newDescription.length <= 255) {
      this._description = newDescription;
    }
  }
  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      this._priority = newPriority;
    }
  }
  set date(String newDate) {
    this._date = newDate;
  }

  // Convert a Note object into a Map object
  //Map<String, dynamic> because key is in form of string and its value are in form of int,string,bool
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['date'] = _date;

    return map;
  }

  // Extract a Note object from a Map object
  //take argument as Map Variable convert it into Note object
  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._priority = map['priority'];
    this._date = map['date'];
  }
}


