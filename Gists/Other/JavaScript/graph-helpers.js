function generateRandomColors(count) {
  const colors = [];
  for (let i = 0; i < count; i++) {
    const color = getRandomColor();
    colors.push(color);
  }
  return colors;
}

function getRandomColor() {
  const letters = "0123456789ABCDEF";
  let color = "#";
  for (let i = 0; i < 6; i++) {
    color += letters[Math.floor(Math.random() * 16)];
  }
  return color;
}

function formatDate(date) {
  const options = { month: "short", day: "numeric" };
  return new Date(date).toLocaleDateString("en-US", options);
}
