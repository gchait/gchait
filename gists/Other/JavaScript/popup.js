function showPopupMessage(message) {
  var popup = document.createElement('div');
  popup.className = 'popup-message';
  popup.textContent = message;
  document.body.appendChild(popup);
  setTimeout(function() {
    popup.remove();
  }, 2500);
}
