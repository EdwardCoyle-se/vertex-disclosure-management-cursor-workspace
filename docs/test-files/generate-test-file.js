// Quick script to generate a large test XLSX file
const fs = require('fs');

// Generate CSV data first (much simpler), then save as .xlsx
// This will create a file with many rows and columns of data
const rows = 12000; // Number of rows - adjusted for ~12MB file
const cols = 20; // Number of columns

let csvContent = '';

// Header row
const headers = [];
for (let c = 0; c < cols; c++) {
  headers.push(`Column_${c + 1}`);
}
csvContent += headers.join(',') + '\n';

// Data rows
for (let r = 0; r < rows; r++) {
  const row = [];
  for (let c = 0; c < cols; c++) {
    // Generate various types of data
    if (c === 0) {
      row.push(`Row_${r + 1}`);
    } else if (c === 1) {
      row.push(Math.floor(Math.random() * 100000));
    } else if (c === 2) {
      row.push((Math.random() * 10000).toFixed(2));
    } else {
      row.push(`Sample_Data_${r}_${c}_Lorem_Ipsum_Dolor_Sit_Amet_Consectetur_Adipiscing_Elit`);
    }
  }
  csvContent += row.join(',') + '\n';
  
  // Progress indicator
  if (r % 5000 === 0) {
    console.log(`Generated ${r} rows...`);
  }
}

// Write as CSV first
const filename = 'test-data-large.csv';
fs.writeFileSync(filename, csvContent);

const fileSizeMB = (fs.statSync(filename).size / (1024 * 1024)).toFixed(2);
console.log(`\nFile created: ${filename}`);
console.log(`File size: ${fileSizeMB} MB`);

// Rename to xlsx (Excel will still open it)
const xlsxFilename = 'test-data-large-10MB.xlsx';
fs.renameSync(filename, xlsxFilename);
console.log(`Renamed to: ${xlsxFilename}`);
console.log('\nNote: This is technically a CSV file with .xlsx extension.');
console.log('Excel will open it fine for testing purposes.');

