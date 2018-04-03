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

            //Setup Service
            this.ServiceName = "Red5";
            this.CanStop = true;

            //Setup logging
            this.AutoLog = false;

            ((ISupportInitialize)this.EventLog).BeginInit();
            if (!EventLog.SourceExists(this.ServiceName))
            {
            EventLog.CreateEventSource(this.ServiceName, "Application");
            }
            ((ISupportInitialize)this.EventLog).EndInit();

            this.EventLog.Source = this.ServiceName;
            this.EventLog.Log = "Application";
        }

        protected override void OnStart(string[] args)
        {
            RED5_HOME = System.Environment.GetEnvironmentVariable("RED5_HOME");
            bool home_exists = System.IO.Directory.Exists(RED5_HOME);
            
            if (home_exists)
            {
                try
                {
                    startRed5 = new Process(); // Declare New Process
                    startRed5.StartInfo.WorkingDirectory = RED5_HOME;
                    startRed5.StartInfo.FileName = "red5.bat";
                    startRed5.StartInfo.WindowStyle = System.Diagnostics.ProcessWindowStyle.Hidden;
                    startRed5.StartInfo.CreateNoWindow = true;
                    startRed5.EnableRaisingEvents = true;
                    startRed5.Exited += new EventHandler(red5__Exited);
                    startRed5.Start();
                    
                    PID = startRed5.Id;

                    this.EventLog.WriteEntry("Starting process with PID " + PID);
                }
                catch(Exception e)
                {
                    this.EventLog.WriteEntry("Error starting Red5: " + e.Message);
                    return;
                }
            }
        }

        
        private void red5__Exited(object sender, System.EventArgs e)
        {
            this.Stop();
        }


        protected override void OnStop()
        {
            RED5_HOME = System.Environment.GetEnvironmentVariable("RED5_HOME");
            bool home_exists = System.IO.Directory.Exists(RED5_HOME);


            if (home_exists)
            {
                try
                {

                    /******************************************/
                    /* First try to kill red5 process */

                    try
                    {
                        if (startRed5 != null)
                        {
                            this.EventLog.WriteEntry("Terminating Red5 process");
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
                        this.EventLog.WriteEntry("Error killing Red5 process: " + e.Message);
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

                    this.EventLog.WriteEntry("Stopping process");
                }
                catch(Exception e)
                {
                    this.EventLog.WriteEntry("Error stopping Red5: " + e.Message);
                    return;
                }
            }
        }
    }
}
