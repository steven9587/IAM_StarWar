int button = 2;
int x = A0;

void setup() {
  Serial.begin(9600);
  pinMode(button, INPUT_PULLUP);
  pinMode(x, INPUT_PULLUP);
}

byte data[3];
void loop() {
  int button_State = digitalRead(button);
  int x_State = digitalRead(x);
  data[0] = button_State1;
  if ((x_State - 520) > 0) {
    data[1] = 1;
  }
  if ((x_State - 520) < 0) {
    data[2] = 1;
  }
  Serial.write(data, 3);
  delay(50);
}
