import java.awt.AWTException;
import java.awt.Robot;
import java.awt.event.InputEvent;
import java.awt.event.KeyEvent;

public class testFPS
{
   Robot robot = new Robot();
 
   public static void main(String[] args) throws AWTException
   {
      int iterations = 0;
      if (args.length > 0)
      {
         try
         {
            iterations = Integer.parseInt(args[0]);
         } 
         catch (NumberFormatException e)
         {
            System.err.println("Argument" + args[0] + " must be an integer.");
            System.exit(1);
         }
      }
      new testFPS(iterations);
   }
   
   public testFPS(int iterationCount) throws AWTException
   {
      int counter = iterationCount;
      robot.delay(5000);
      for(int i = 0; i < counter; i++)
      {
         for(int j = 0; j < 30; j++)
         {
	    if((j == 1) || (j == 29))
            {
	       robot.keyPress(KeyEvent.VK_F11);
	       robot.keyRelease(KeyEvent.VK_F11);
	    }
            rotate3d();
    	 }
      }
      System.exit(0);
   }

   private void rotate3d()
   {
      robot.mouseMove(400, 400);
      robot.mousePress(InputEvent.BUTTON1_MASK);
      for(int i = 0; i < 20; i++)
      {
         robot.mouseMove(400 + (i * 25), 400 + (i * 25));
	 robot.delay(10);
      }
      robot.mouseRelease(InputEvent.BUTTON1_MASK);
   }
}