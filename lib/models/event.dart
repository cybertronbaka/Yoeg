
class Event{
  String eventTitle;
  String description;
  String venue;
  String maxVolunteer;
  String maxParticipant;
  String startDate;
  String endDate;
  String organizerUID;
  String eventPic = 'Events/defeventposter.jpg';
  String postDate;
  String participantProc;
  String volunteerProc;

  Event(this.eventTitle,this.description, this.venue, this.maxVolunteer, this.maxParticipant, this.startDate, this.endDate, this.organizerUID, this.postDate,{this.eventPic});

  Map<String, dynamic> toJson() => {
    'title': eventTitle,
    'description': description,
    'venue': venue,
    'maxVolunteer': maxVolunteer,
    'maxParticipant': maxParticipant,
    'startDate': startDate,
    'endDate': endDate,
    'organizerUID':organizerUID,
    'eventPic': "Events/defeventposter.jpg",
    'postDate': postDate,
    'participateProc': "Simple",
    'volunteerProc': "Simple",
    'participationPDF': null,
    'volunteerPDF':null,
  };
}