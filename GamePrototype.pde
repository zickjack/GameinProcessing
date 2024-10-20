int x = 1;
int y = 1;
int squaresize = 50;
int healthpointsize = 20;
int movingspeed = 3;
int healthpoints = 3;
int maxEnemies = 10; // Max number of enemies (adjust as needed)
int damageCooldown = 60; // Cooldown time in frames (1 second if 60 fps)
int damageTimer = 0;     // Tracks time since last damage
int[] enemyX = new int[maxEnemies];
int[] enemyY = new int[maxEnemies];
boolean[] enemyActive = new boolean[maxEnemies];
int enemyCount = 0; // Tracks the number of enemies spawned
int lastX, lastY;  // Variables to store the player's last position
int currentlevel = 1;

boolean leftPressed = false;
boolean rightPressed = false;
boolean upPressed = false;
boolean downPressed = false;
float armRadius = 30; // Max distance the arm can be from the body

float armX, armY; // Store the position of the player's arm

// Arrays to store bullet positions and velocities
float[] bulletX = new float[100];
float[] bulletY = new float[100];
float[] bulletVelX = new float[100];
float[] bulletVelY = new float[100];
boolean[] bulletActive = new boolean[100]; // To track if a bullet is active
int bulletIndex = 0; // To track the current bullet

boolean playerActive = true; // Track if the player is alive

// Enemy variables
int[][] level1 = {         // 3 indicates the player’s starting position, 2 indicates the enemy position, 1 indicates the placement of walls, and 0 indicates the tile being empty.
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
};

int[][] level2 = {         
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 3, 0, 4, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
};
int[][] level3 = {         
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 3, 0, 4, 1, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
};
// Variable to store the current level layout
int[][] level = level1;

boolean showGrid = false;

void setup() {
  size(720, 500);
  // Initialize bulletActive array
  for (int i = 0; i < bulletActive.length; i++) {
    bulletActive[i] = false;
  }
  spawnEntitiesFromLevel();
}

void draw() {
  background(0);
  
  // Draw the level based on the array
  drawLevel();

  // Draw the grid if showGrid is true
  if (showGrid) {
    drawGrid();
  }

  // Only draw and move the player if they are active
  if (playerActive) {
    fill(0, 255, 500); // Blue color for the player
    square(x, y, squaresize);
    
    // Call the moveCharacter function
    moveCharacter();
    
    checkForLevelChange();  // Check if the player touched a door

    // Draw arm following the mouse
    drawArm();
  }
  if (healthpoints == 3){
  fill (0,255,0);
  circle(20,20,healthpointsize);
  
  fill (0,255,0);
  circle(40,20,healthpointsize);
  
  fill (0,255,0);
  circle(60,20,healthpointsize);
  
  }
  if (healthpoints == 2){
  fill (0,255,0);
  circle(20,20,healthpointsize);
  
  fill (0,255,0);
  circle(40,20,healthpointsize);
  
  
  }
  if (healthpoints == 1){
  fill (0,255,0);
  circle(20,20,healthpointsize); 
  }
  
  
  
  
  // Move and draw all active bullets
  drawBullets();
  
  // Move and draw the enemy
  moveAndDrawEnemy();
}

void spawnEntitiesFromLevel() {
  enemyCount = 0; // Reset enemy count for the new level
  
  for (int row = 0; row < level.length; row++) {
    for (int col = 0; col < level[0].length; col++) {
      if (level[row][col] == 2 && enemyCount < maxEnemies) {
        enemyX[enemyCount] = col * squaresize;
        enemyY[enemyCount] = row * squaresize;
        enemyActive[enemyCount] = true;
        enemyCount++; 
      }
      if (level[row][col] == 3) {
        x = col * squaresize;  // Set player starting position
        y = row * squaresize;
      }
    }
  }
}



// AABB collision detection between player and enemy
boolean checkCollision(float playerX, float playerY, float enemyX, float enemyY, float size) {
  return (playerX < enemyX + size && playerX + size > enemyX &&
          playerY < enemyY + size && playerY + size > enemyY);
}

// AABB collision detection between bullet and enemy
boolean checkBulletCollision(float bulletX, float bulletY, float enemyX, float enemyY, float size) {
  return (bulletX < enemyX + size && bulletX + 10 > enemyX && // Assuming bullet size is 10
          bulletY < enemyY + size && bulletY + 10 > enemyY);
}

void checkForLevelChange() {
  int playerGridX = x / squaresize;
  int playerGridY = y / squaresize;

  if (level[playerGridY][playerGridX] == 4) {
    currentlevel++;
    loadLevel();
  }
}

void loadLevel() {
  if (currentlevel == 2) {
    level = level2;  // Switch to level 2
  }
  else {
    level = level1;  // Reset to level 1 (or you can have more levels)
  }

  // Respawn the player and enemies based on the new level layout
  spawnEntitiesFromLevel();
}


// Function to draw the level from the 2D array
void drawLevel() {
  for (int row = 0; row < level.length; row++) {
    for (int col = 0; col < level[0].length; col++) {
      int cellValue = level[row][col];
      
      if (cellValue == 1) {
        // Draw wall as a white square
        fill(150,75,0);
        square(col * squaresize, row * squaresize, squaresize);
      }
      // We don't need to draw the enemy here as it is handled separately
    }
  }
}

// Function to move the player and ensure proper wall collision
void moveCharacter() {
  // Save the player's last position before moving
  lastX = x;
  lastY = y;
  
  // Check which key is pressed and move accordingly
  if (leftPressed) {
    x -= movingspeed;  // Move left
    if (checkWallCollision(x, y)) {
      x = lastX; // Revert if collision
    }
  }
  if (rightPressed) {
    x += movingspeed;  // Move right
    if (checkWallCollision(x, y)) {
      x = lastX; // Revert if collision
    }
  }
  if (upPressed) {
    y -= movingspeed;  // Move up
    if (checkWallCollision(x, y)) {
      y = lastY; // Revert if collision
    }
  }
  if (downPressed) {
    y += movingspeed;  // Move down
    if (checkWallCollision(x, y)) {
      y = lastY; // Revert if collision
    }
  }
}

// Function to check if the player is colliding with a wall, based on the level grid
boolean checkWallCollision(int playerX, int playerY) {
  // Check the four corners of the player's square
  int topLeftX = playerX / squaresize;
  int topLeftY = playerY / squaresize;
  
  int topRightX = (playerX + squaresize - 1) / squaresize;
  int topRightY = playerY / squaresize;
  
  int bottomLeftX = playerX / squaresize;
  int bottomLeftY = (playerY + squaresize - 1) / squaresize;
  
  int bottomRightX = (playerX + squaresize - 1) / squaresize;
  int bottomRightY = (playerY + squaresize - 1) / squaresize;
  
  // Ensure we are only checking within the level bounds
  if (topLeftY >= level.length || bottomRightY >= level.length ||
      topLeftX >= level[0].length || bottomRightX >= level[0].length) {
    return false;  // Out-of-bounds means no wall, player can move freely
  }
  
  // Check if any of these corners are colliding with a wall (grid value 1)
  return (level[topLeftY][topLeftX] == 1 || 
          level[topRightY][topRightX] == 1 || 
          level[bottomLeftY][bottomLeftX] == 1 || 
          level[bottomRightY][bottomRightX] == 1);
}
  
  

void keyPressed() {
  // Set boolean flags when keys are pressed
  if (key == 'a' || key == 'A') {
    leftPressed = true;
  }
  if (key == 'd' || key == 'D') {
    rightPressed = true;
  }
  if (key == 'w' || key == 'W') {
    upPressed = true;
  }
  if (key == 's' || key == 'S') {
    downPressed = true;
  }
}

void keyReleased() {
  // Reset boolean flags when keys are released
  if (key == 'a' || key == 'A') {
    leftPressed = false;
  }
  if (key == 'd' || key == 'D') {
    rightPressed = false;
  }
  if (key == 'w' || key == 'W') {
    upPressed = false;
  }
  if (key == 's' || key == 'S') {
    downPressed = false;
  }
}

// Function to fire a bullet from the player's arm
void fireBullet() {
  // Calculate the direction vector from the arm to the mouse
  float dirX = mouseX - armX;
  float dirY = mouseY - armY;
  
  // Normalize the direction vector
  float length = dist(armX, armY, mouseX, mouseY);
  dirX /= length;
  dirY /= length;

  // Set the bullet's position to the arm's position
  bulletX[bulletIndex] = armX;
  bulletY[bulletIndex] = armY;
  
  // Set the bullet's velocity based on the direction
  bulletVelX[bulletIndex] = dirX * 5; // Bullet speed
  bulletVelY[bulletIndex] = dirY * 5;

  // Activate the bullet
  bulletActive[bulletIndex] = true;

  // Increment bullet index, wrap around if needed
  bulletIndex = (bulletIndex + 1) % bulletX.length;
}

// Function to move and draw all bullets
void drawBullets() {
  for (int i = 0; i < bulletX.length; i++) {
    if (bulletActive[i]) {
      // Move the bullet
      bulletX[i] += bulletVelX[i];
      bulletY[i] += bulletVelY[i];

      // Draw the bullet
      fill(250, 0, 0);
      ellipse(bulletX[i], bulletY[i], 10, 10);

      // Check if bullet hits any enemy
      for (int j = 0; j < enemyCount; j++) {
        if (enemyActive[j] && checkBulletCollision(bulletX[i], bulletY[i], enemyX[j], enemyY[j], squaresize)) {
          enemyActive[j] = false; // Destroy the enemy
          bulletActive[i] = false; // Deactivate the bullet
        }
      }

      // Deactivate the bullet if it goes off-screen
      if (bulletX[i] < 0 || bulletX[i] > width || bulletY[i] < 0 || bulletY[i] > height) {
        bulletActive[i] = false;
      }
    }
  }
}

void moveAndDrawEnemy() {
  for (int i = 0; i < enemyCount; i++) {
    if (enemyActive[i]) {
      // Move the enemy towards the player
      if (enemyX[i] < x) {
        enemyX[i] += movingspeed - 2;
      }
      if (enemyX[i] > x) {
        enemyX[i] -= movingspeed - 2;
      }
      if (enemyY[i] < y) {
        enemyY[i] += movingspeed - 2;
      }
      if (enemyY[i] > y) {
        enemyY[i] -= movingspeed - 2;
      }

      // Draw the enemy as a red square
      fill(255, 0, 0);
      square(enemyX[i], enemyY[i], squaresize);

      // Check if the enemy touches the player and the cooldown has passed
      if (checkCollision(x, y, enemyX[i], enemyY[i], squaresize) && damageTimer == 0) {
        healthpoints -= 1;
        damageTimer = damageCooldown;  // Start the cooldown timer
      }  
      
      // If health reaches 0, end the game
      if (healthpoints == 0) {
        playerActive = false; // Player "dies"
        exit();
      }
    }
  }

  // Decrease the damage timer each frame, ensuring the player can only take damage after the cooldown has passed
  if (damageTimer > 0) {
    damageTimer--;
  }
}




// Function to move and draw the enemy
void moveAndDrawEnemies() {
  for (int i = 0; i < enemyCount; i++) {
    if (enemyActive[i]) {
      // Move the enemy towards the player
      if (enemyX[i] < x) {
        enemyX[i] += movingspeed - 2;
      }
      if (enemyX[i] > x) {
        enemyX[i] -= movingspeed - 2;
      }
      if (enemyY[i] < y) {
        enemyY[i] += movingspeed - 2;
      }
      if (enemyY[i] > y) {
        enemyY[i] -= movingspeed - 2;
      }

      // Draw the enemy as a red square
      fill(255, 0, 0);
      square(enemyX[i], enemyY[i], squaresize);

      // Check if the enemy touches the player
      if (checkCollision(x, y, enemyX[i], enemyY[i], squaresize)) {
        playerActive = false; // Player "dies" if collision occurs
      }
    }
  }
}


// Function to draw the player's arm
void drawArm() {
  // Get direction vector from player to mouse
  float dirX = mouseX - (x + squaresize / 2);
  float dirY = mouseY - (y + squaresize / 2);
  
  // Normalize the direction vector
  float length = dist(x + squaresize / 2, y + squaresize / 2, mouseX, mouseY);
  dirX /= length;
  dirY /= length;
  
  // Limit the arm's position to a max distance (armRadius)
  armX = (x + squaresize / 2) + dirX * armRadius;
  armY = (y + squaresize / 2) + dirY * armRadius;
  
  // Draw the arm (circle)
  fill(255, 0, 0);
  ellipse(armX, armY, 20, 20);
}

// Function to handle mouse clicks
void mousePressed() {
  // Fire a bullet when the left mouse button is clicked
  if (mouseButton == LEFT) {
    fireBullet();
  }
}

// Function to draw a grid (can be toggled on/off)
void drawGrid() {
  stroke(100);
  for (int i = 0; i < width; i += squaresize) {
    line(i, 0, i, height);
  }
  for (int j = 0; j < height; j += squaresize) {
    line(0, j, width, j);
  }
}
