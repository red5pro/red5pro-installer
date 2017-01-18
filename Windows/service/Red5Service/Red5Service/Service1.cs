using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.ServiceProcess;
using System.Text;

namespace Red5Service
{
    public partial class Service1 : ServiceBase
    {
        String RED5_HOME = "C:\\Users\\Rajdeep\\Downloads\\red5-server-1.0.8-RELEASE";
        Process startRed5;
        Process stopRed5;

        int PID;

        public Service1()
        {
            InitializeComponent();
        }

        protected override void OnStart(string[] args)
        {
            RED5_HOME = System.Environment.GetEnvironmentVariable("RED5_HOME");
            bool home_exists = System.IO.Directory.Exists(RED5_HOME);
            
            if (home_exists)
            {
                startRed5 = new Process(); // Declare New Process
                startRed5.StartInfo.WorkingDirectory = RED5_HOME;
                startRed5.StartInfo.FileName = "red5.bat";
                startRed5.StartInfo.WindowStyle = System.Diagnostics.ProcessWindowStyle.Hidden;
                startRed5.StartInfo.CreateNoWindow = true;
                startRed5.Start();

                PID = startRed5.Id;

                string lines = PID.ToString();
                System.IO.StreamWriter file = new System.IO.StreamWriter(RED5_HOME + "\\PID.txt");
                file.WriteLine(lines);
                file.Close();
            }
        }

        protected override void OnStop()
        {
            RED5_HOME = System.Environment.GetEnvironmentVariable("RED5_HOME");
            bool home_exists = System.IO.Directory.Exists(RED5_HOME);


            if (home_exists)
            {
                /******************************************/
                /* First try to kill red5 process */

                try
                {
                    if (startRed5 != null)
                    {
                        startRed5.CloseMainWindow();
                        startRed5.Kill();
                    }
                    else
                    {
                        Process.GetProcessById(PID).Kill();
                    }
                    
                }
                catch (Exception e)
                {
                    string lines = e.Message;
                    System.IO.StreamWriter file = new System.IO.StreamWriter(RED5_HOME + "\\service_error.log");
                    file.WriteLine(lines);
                    file.Close();
                }
                finally
                {
                    startRed5 = null;
                }


                /******************************************/
                /* Try to run shutdown script */

                stopRed5 = new Process();
                stopRed5.StartInfo.WorkingDirectory = RED5_HOME;
                stopRed5.StartInfo.FileName = "red5-shutdown.bat";
                stopRed5.StartInfo.Arguments = "force";
                stopRed5.StartInfo.WindowStyle = System.Diagnostics.ProcessWindowStyle.Hidden;
                stopRed5.StartInfo.CreateNoWindow = true;
                stopRed5.Start();
            }
        }
    }
}
