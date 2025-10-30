<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>ScripterJoiner Page</title>
<style>
  body {
    margin: 0;
    font-family: Arial, sans-serif;
    background-color: #f2f2f2;
  }

  /* Top-right blue download button */
  .download-btn {
    position: fixed;
    top: 10px;
    right: 10px;
    background-color: #007bff;
    color: white;
    padding: 12px 20px;
    border: none;
    border-radius: 10px;
    cursor: pointer;
    z-index: 1000;
  }

  .download-btn:hover {
    background-color: #0056b3;
  }

  /* Black overlay */
  .overlay {
    display: none;
    position: fixed;
    top: 0; left: 0;
    width: 100%; height: 100%;
    background-color: rgba(0,0,0,0.95);
    z-index: 999;
  }

  /* Draggable scripterjoiner button */
  #scripterjoiner {
    position: absolute;
    top: 20px;
    right: 20px;
    background-color: #007bff;
    color: white;
    padding: 10px 15px;
    border-radius: 10px;
    cursor: grab;
    z-index: 1001;
  }

  /* Player search area */
  #playerSearchContainer {
    margin: 80px auto 0 auto;
    width: 300px;
    text-align: center;
    color: white;
  }

  #playerSearchContainer input {
    width: 100%;
    padding: 8px;
    border-radius: 6px;
    border: none;
    margin-bottom: 10px;
  }

  #playerInfo {
    background-color: #111;
    padding: 10px;
    border-radius: 6px;
    min-height: 60px;
  }

  /* Player action panel */
  #playerActions {
    display: none;
    position: fixed;
    top: 10px;
    left: 10px;
    background-color: black;
    color: white;
    padding: 15px;
    border-radius: 10px;
    z-index: 2000;
    width: 260px;
  }

  #playerActions button {
    width: 100%;
    padding: 8px;
    border: none;
    border-radius: 8px;
    margin-top: 8px;
    font-size: 15px;
    cursor: pointer;
  }

  #reportBtn { background-color: #007bff; color: white; }
  #dontReportBtn { background-color: #555; color: white; }
  #blockBtn { background-color: #e74c3c; color: white; }
</style>
</head>
<body>

<!-- Download button -->
<button class="download-btn" onclick="downloadFile()">Download 227MB</button>

<!-- Overlay -->
<div class="overlay" id="overlay">
  <div id="scripterjoiner">scripterjoiner</div>

  <div id="playerSearchContainer">
    <input type="text" id="playerSearch" placeholder="Search Player">
    <div id="playerInfo">Player info will appear here</div>
  </div>
</div>

<!-- Player action panel -->
<div id="playerActions">
  <h3 id="playerName">Player</h3>
  <button id="reportBtn">Report Player</button>
  <button id="dontReportBtn">Don’t Report</button>
  <button id="blockBtn">Report & Block Player</button>
</div>

<script>
  // Example player list (demo)
  const players = [
    {name: 'Alice', joined: '2025-01-15', online: true},
    {name: 'Bob', joined: '2024-12-01', online: false},
    {name: 'Charlie', joined: '2025-06-20', online: true},
  ];

  function downloadFile() {
    document.getElementById('overlay').style.display = 'block';

    const link = document.createElement('a');
    link.href = 'path_to_your_227MB_file.zip'; // Replace with your file URL
    link.download = 'your_file.zip';
    link.click();
  }

  const searchBox = document.getElementById('playerSearch');
  const playerInfo = document.getElementById('playerInfo');
  const playerActions = document.getElementById('playerActions');
  const playerNameTitle = document.getElementById('playerName');
  const blockBtn = document.getElementById('blockBtn');

  searchBox.addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
      const query = searchBox.value.trim();
      const player = players.find(p => p.name.toLowerCase() === query.toLowerCase());
      if(player) {
        playerInfo.innerHTML = `
          Name: ${player.name} <br>
          Joined: ${player.joined} <br>
          Online: ${player.online ? '<span style="color:blue">Yes</span>' : 'No'}
        `;

        // When player is clicked, show player actions
        playerInfo.onclick = () => {
          playerNameTitle.textContent = player.name;
          blockBtn.textContent = `Report & Block ${player.name}`;
          playerActions.style.display = 'block';
        };
      } else {
        playerInfo.innerHTML = 'No user found☄️';
        playerActions.style.display = 'none';
      }
    }
  });

  // Draggable scripterjoiner
  const dragBtn = document.getElementById('scripterjoiner');
  let isDragging = false;
  let offsetX, offsetY;

  dragBtn.addEventListener('mousedown', (e) => {
    isDragging = true;
    offsetX = e.clientX - dragBtn.getBoundingClientRect().left;
    offsetY = e.clientY - dragBtn.getBoundingClientRect().top;
  });

  document.addEventListener('mousemove', (e) => {
    if(isDragging) {
      dragBtn.style.left = (e.clientX - offsetX) + 'px';
      dragBtn.style.top = (e.clientY - offsetY) + 'px';
    }
  });

  document.addEventListener('mouseup', () => {
    isDragging = false;
  });

  // Button actions
  document.getElementById('reportBtn').onclick = () => {
    alert('Player has been reported.');
  };

  document.getElementById('dontReportBtn').onclick = () => {
    playerActions.style.display = 'none';
  };

  blockBtn.onclick = () => {
    alert(blockBtn.textContent + ' has been blocked.');
    playerActions.style.display = 'none';
  };
</script>

</body>
</html>
