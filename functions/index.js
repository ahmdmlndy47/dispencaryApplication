const {setGlobalOptions} = require("firebase-functions");
const {onDocumentUpdated} = require("firebase-functions/v2/firestore");

setGlobalOptions({
  maxInstances: 10,
});

exports.checkAppointmentNumber = onDocumentUpdated(
  "countries/{countryId}/dispensaries/{disId}/patients/{patientId}/appointment/{appointmentId}",
  async (event) => {

    const before = event.data.before.data();
    const after = event.data.after.data();

    console.log("قبل:", before);
    console.log("بعد:", after);

    return null;
  }
);