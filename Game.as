package
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	
	public class Game2 extends MovieClip
	{
		private var speed:int; //how fast hero will move between spaces
		private var dx:int; //x distance between hero and destination space
		private var dy:int; //y distance
		private var btnList:Array; //list of buttons
		private var mB0List:Array; //list of components of rotatable block in target position
		private var mB1List:Array; //list of components of rotatable block in starting position
		private var blockList:Array; //list of which block each space is on
		private var heroCurrentSpace:int; //space that hero is currently on
		private var heroCurrentBlock:int; //block that hero is currently on
		private var count:int; //tracks number of times enterFrameListener occurs
		private var ind:int; //intermediate button index, adjacent to hero's current space index
		private var constant:int; //1 or -1, which direction 
		private var endInd:int; //index num of destination button in btnList Array
		private var rotateCnt:int; //which position rotatable block is in
		private var countOfMoves:int; //how many times the hero moves between spaces
		private var mBList:Array; 
		private var bobSpeed:Number 

		public function Game2()
		{
			stop();
			bobSpeed = 0.5;
			addEventListener(Event.ENTER_FRAME, bob); //triangle animation
			blockList = new Array();
			heroCurrentSpace = 1;
			heroCurrentBlock = 0;
			speed = 2;
			countOfMoves = 0;
			rotateCnt = 1;
			startLevel();
		}
			
		public function bob(event:Event):void
		{
			triangle.y += bobSpeed;
			if (triangle.y == 102 || triangle.y == 88)
			{
				bobSpeed *= -1;
			}
		}
		
		public function startLevel():void
		{
			btnList = [spaceBtn00, spaceBtn01, spaceBtn02, spaceBtn03, spaceBtn04, spaceBtn05, 
						spaceBtn06, spaceBtn07, spaceBtn08, spaceBtn09, movable0Btn10, movable0Btn11,
						movable0Btn12, movable0Btn13, movable0Btn14, movable0Btn15, movable0Btn16, spaceBtn17,
						spaceBtn18, spaceBtn19, spaceBtn20, spaceBtn21, spaceBtn22, spaceBtn23,
						spaceBtn24, spaceBtn25, spaceBtn26, spaceBtn27];
			mB0List = [rotateBtn0, mBlock0shadow, movable0Btn10, movable0Btn11, movable0Btn12,
						movable0Btn13, movable0Btn14, movable0Btn15, movable0Btn16];
			mB1List = [rotateBtn1, mBlock1shadow, movable1Btn13, movable1Btn14, movable1Btn15, movable1Btn16];
			mBList = [mB0List, mB1List];
			setRotBtns();
			createSpaceBtns();
			setVisibilities();
			setButtons();
			turnOnMBtns();
			setBlockNums();
		}
		
		public function setRotBtns():void //buttons to rotate block
		{
			rotateBtn0.addEventListener(MouseEvent.CLICK, rotateBlock);
			rotateBtn1.addEventListener(MouseEvent.CLICK, rotateBlock);
		}
		
		public function createSpaceBtns():void
		{
			for each (var btn in btnList) //adding click listeners to each button
			{
				btn.addEventListener(MouseEvent.CLICK, moveHere(int(btn.name.substr(btn.name.length - 2,2)))); 
				//if click event occurs, moveHere is passed the index of the button in btnList
			}
			
			for each (var ray in mBList) //adding click listeners to buttons on movable block
			{
				for (var i:int = 2; i < ray.length; i++)
				{
					ray[i].addEventListener(MouseEvent.CLICK, moveHere(int(ray[i].name.substr(ray[i].name.length - 2,2)))); 
				}
			}
		}
		
		public function rotateBlock(event:MouseEvent):void
		{
			if (heroCurrentSpace < 10 || heroCurrentSpace > 16) //can only rotate if hero is not on movable block
			{
				if (rotateCnt == 0)
				{
					rotateCnt = 1;
				}
				else
				{
					rotateCnt = 0;
				}
				setVisibilities();
				setButtons();
				turnOnMBtns();
				setBlockNums();
			}
		}
		
		public function setButtons():void 
		//replaces buttons in btnList with appropriate movable block space buttons
		{
			var j:int = 2;
			for (var i:int = 10; i < (mBList[rotateCnt].length - 2) + 9; i++)
			{
				btnList[i] = mBList[rotateCnt][j];
				j++;
			}
		}
		
		public function turnOnMBtns():void
		{
			for (var j:int = 0; j < 2; j++)
			{
				if (j != rotateCnt)
				{
					for (var i:int = 1; i < mBList[j].length; i++)
					{
						mBList[j][i].mouseEnabled = false;
					}
				}
				else
				{
					for (var i:int = 1; i < mBList[j].length; i++)
					{
						mBList[j][i].mouseEnabled = true;
					}
				}
			}
		}
		
		public function moveHere(spaceInd:int):Function
		{
			return function(event:MouseEvent):void
			{
				trace("hero block" + heroCurrentBlock);
				trace("block num" + blockList[spaceInd]);
				trace("" + spaceInd);
				countOfMoves = 0;
				constant = 1; //forward
				endInd = spaceInd;
				if (blockList[spaceInd] == heroCurrentBlock && spaceInd != heroCurrentSpace)
					//checks if hero can move to space/needs to move
					//hero can only move is target space is on the same block (same block number)
				{
					if (spaceInd < heroCurrentSpace) //determines direction of movement
					{
						constant = -1; //backward
					}

					ind = heroCurrentSpace + constant; //index of next adjacent space
					addEventListener(Event.ENTER_FRAME, enterFrameListener);
					
					
					turnOnMouseEvents(false); //disables mouse events when hero is moving
				}
			};
		}
		
		public function enterFrameListener(event:Event):void
		{
				countOfMoves++; //counts how many times enterFrameListener runs
			
				dx = btnList[ind].x - hero.x; 
				dy = btnList[ind].y - hero.y;
				var dh:int = Math.sqrt(dx*dx + dy*dy); //hypotenuse 
				
				if (countOfMoves == 14 && ind != endInd) //count at 15 means hero is at the next space
				{					//constant 15 varies with speed and distance between spaces
					
					hero.x = btnList[ind].x;
					hero.y = btnList[ind].y;
					
					ind += constant; //aim for next space
					countOfMoves = 0; //reset count
					trace("new ind" + ind);
				}
				else if (countOfMoves == 14 && ind == endInd) //exits when hero is at target space
				{
					hero.x = btnList[ind].x;
					hero.y = btnList[ind].y;

					removeEventListener(Event.ENTER_FRAME, enterFrameListener);
					trace("exited");
					heroCurrentSpace = endInd;

					turnOnMouseEvents(true); //mouse events enabled again
				}
				else //move hero
				{	
					hero.x += speed*(dx/dh);
					hero.y += speed*(dy/dh);
					trace("moving" + countOfMoves);
				}
		}
		
		public function turnOnMouseEvents(b:Boolean):void //turns on/off all buttons when hero in motion
		{
			for each (var btn in btnList)
			{
				btn.mouseEnabled = b;
			}
			rotateBtn0.mouseEnabled = b;
			rotateBtn1.mouseEnabled = b;
		}
		
		public function setVisibilities():void //sets visibilites of positions of rotatable block
		{
			for (var i:int = 0; i < 2; i++)
			{
				if (i != rotateCnt)
				{
					for each (var piece in mBList[i])
					{
						piece.visible = false;
					}
				}
				else
				{
					for each (var piece in mBList[i])
					{
						piece.visible = true;
					}
				}
			}
		}
		
		public function setBlockNums():void
		//each space's assignment to a block number permits/prevents movement of hero to the respective space
		{
			if (rotateCnt == 1 && heroCurrentSpace > 16)
			{
				heroCurrentBlock = 1;
			}
			else
			{
				heroCurrentBlock = 0;
			}
			if (rotateCnt == 0) //if rotatable block in target position, all spaces are on block 0
			{
				for (var i:int = 0; i < 28; i++)
				{
					blockList[i] = 0;
				}
			}
			else //if rotatable block in starting position, only first 9 spaces are on block 0
			{
				for (var i:int = 0; i < 10; i++)
				{
					blockList[i] = 0;
				}
				for (var i:int = 10; i < 28; i++)
				{
					blockList[i] = 1;
				}
			}
		}
	}
}
