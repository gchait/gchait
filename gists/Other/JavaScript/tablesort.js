// Get all tables on the page
const tables = document.querySelectorAll('table');

tables.forEach(function (table) {
  // Query all headers in the current table
  const headers = table.querySelectorAll('th');

  // Track sort directions for each column
  const directions = Array.from(headers).map(function (header) {
    return '';
  });

  // Transform the content of a cell based on its data type
  const transform = function (index, content) {
    const type = headers[index].getAttribute('data-type');
    switch (type) {
      case 'number':
        if (content.startsWith('$')) {
            content = content.substring(1);
        } else if (content.endsWith('%')) {
            content = content.substring(0, content.length - 1);
        }

        content = content.replace(/,/g, '');
        return parseFloat(content);
      default:
        return content;
    }
  };

  // Sort the column when a header is clicked
  const sortColumn = function (index) {
    // Get the current sort direction
    const direction = directions[index] || 'asc';

    // Determine the sorting multiplier based on the direction
    const multiplier = direction === 'asc' ? 1 : -1;

    // Query the table body and all rows
    const tableBody = table.querySelector('tbody');
    const rows = Array.from(tableBody.querySelectorAll('tr'));

    // Separate rows with "bottom" data-type from other rows
    const rowsWithBottom = [];
    const rowsWithoutBottom = [];

    rows.forEach(function (row) {
      const cell = row.querySelectorAll('td')[index];
      const dataType = cell.getAttribute('data-type');

      if (dataType === 'bottom') {
        rowsWithBottom.push(row);
      } else {
        rowsWithoutBottom.push(row);
      }
    });

    // Sort rows without "bottom" data-type
    const sortedRows = rowsWithoutBottom.sort(function (rowA, rowB) {
      const cellA = rowA.querySelectorAll('td')[index].innerHTML;
      const cellB = rowB.querySelectorAll('td')[index].innerHTML;
      const a = transform(index, cellA);
      const b = transform(index, cellB);

      // Case-insensitive comparison for strings
      const stringCompare = typeof a === 'string' && typeof b === 'string'
        ? a.toLowerCase().localeCompare(b.toLowerCase())
        : 0;

      // Numeric comparison for floats
      const numericCompare = typeof a === 'number' && typeof b === 'number'
        ? (a - b)
        : 0;

      return stringCompare !== 0 ? stringCompare * multiplier : numericCompare * multiplier;
    });

    // Remove existing rows from the table
    rows.forEach(function (row) {
      tableBody.removeChild(row);
    });

    // Append sorted rows without "bottom" data-type
    sortedRows.forEach(function (newRow) {
      tableBody.appendChild(newRow);
    });

    // Append rows with "bottom" data-type
    rowsWithBottom.forEach(function (row) {
      tableBody.appendChild(row);
    });

    // Update the sort direction and data-dir attribute
    directions[index] = direction === 'asc' ? 'desc' : 'asc';
    headers.forEach(function (header, i) {
      if (i === index) {
        header.setAttribute('data-dir', direction);
      } else {
        header.removeAttribute('data-dir');
      }
    });
  };

  // Attach click event listeners to the headers
  headers.forEach(function (header, index) {
    header.addEventListener('click', function () {
      sortColumn(index);
    });
  });
});
