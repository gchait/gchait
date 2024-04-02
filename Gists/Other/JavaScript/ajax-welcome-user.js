$(document).ready(function () {
  $.ajax({
    url: "/my-name",
    type: "GET",
    success: function (userName) {
      $(".user-name").text("Hello, " + userName + "!");
      checkAccessPermission();
    },
    error: function () {
      $(".user-name").text("Hello, Unknown User!");
    },
  });

  function checkAccessPermission() {
    $.ajax({
      url: "/restricted",
      type: "GET",
      success: function () {
        $(".user-name").addClass("admin-color");
      },
      error: function (xhr) {
        if (xhr.status !== 200) {
          $(".user-name").removeClass("admin-color");
        }
      },
    });
  }
});
