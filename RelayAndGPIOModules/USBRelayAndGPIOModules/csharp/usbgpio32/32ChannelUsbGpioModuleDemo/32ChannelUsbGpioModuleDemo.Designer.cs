namespace _32ChannelUsbGpioDemo
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form1));
            this.gpiosetButton = new System.Windows.Forms.Button();
            this.readallBox = new System.Windows.Forms.TextBox();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.label2 = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.verButton = new System.Windows.Forms.Button();
            this.verBox = new System.Windows.Forms.TextBox();
            this.comportNumberbox = new System.Windows.Forms.TextBox();
            this.openportButton = new System.Windows.Forms.Button();
            this.groupBox3 = new System.Windows.Forms.GroupBox();
            this.label4 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.adcstatusBox = new System.Windows.Forms.TextBox();
            this.adcNumberBox = new System.Windows.Forms.TextBox();
            this.adcButton = new System.Windows.Forms.Button();
            this.groupBox4 = new System.Windows.Forms.GroupBox();
            this.writeallBox = new System.Windows.Forms.TextBox();
            this.dirBox = new System.Windows.Forms.TextBox();
            this.maskBox = new System.Windows.Forms.TextBox();
            this.readallButton = new System.Windows.Forms.Button();
            this.writeallButton = new System.Windows.Forms.Button();
            this.iodirButton = new System.Windows.Forms.Button();
            this.iomaskButton = new System.Windows.Forms.Button();
            this.idnumberBox = new System.Windows.Forms.TextBox();
            this.idsetButton = new System.Windows.Forms.Button();
            this.idgetBox = new System.Windows.Forms.TextBox();
            this.idgetButton = new System.Windows.Forms.Button();
            this.serialPort1 = new System.IO.Ports.SerialPort(this.components);
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.label6 = new System.Windows.Forms.Label();
            this.groupBox5 = new System.Windows.Forms.GroupBox();
            this.groupBox7 = new System.Windows.Forms.GroupBox();
            this.label7 = new System.Windows.Forms.Label();
            this.label8 = new System.Windows.Forms.Label();
            this.gpiostatusShowBox = new System.Windows.Forms.TextBox();
            this.gpioNumberReadBox = new System.Windows.Forms.TextBox();
            this.gpioreadButton = new System.Windows.Forms.Button();
            this.groupBox6 = new System.Windows.Forms.GroupBox();
            this.label5 = new System.Windows.Forms.Label();
            this.setStatusBox = new System.Windows.Forms.TextBox();
            this.gpioNumberBox = new System.Windows.Forms.TextBox();
            this.groupBox8 = new System.Windows.Forms.GroupBox();
            this.groupBox1.SuspendLayout();
            this.groupBox3.SuspendLayout();
            this.groupBox4.SuspendLayout();
            this.groupBox2.SuspendLayout();
            this.groupBox5.SuspendLayout();
            this.groupBox7.SuspendLayout();
            this.groupBox6.SuspendLayout();
            this.groupBox8.SuspendLayout();
            this.SuspendLayout();
            // 
            // gpiosetButton
            // 
            this.gpiosetButton.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.gpiosetButton.Location = new System.Drawing.Point(7, 13);
            this.gpiosetButton.Name = "gpiosetButton";
            this.gpiosetButton.Size = new System.Drawing.Size(104, 70);
            this.gpiosetButton.TabIndex = 8;
            this.gpiosetButton.Text = "set / clear";
            this.gpiosetButton.UseVisualStyleBackColor = true;
            this.gpiosetButton.Click += new System.EventHandler(this.gpiosetButton_Click);
            // 
            // readallBox
            // 
            this.readallBox.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.readallBox.Location = new System.Drawing.Point(126, 96);
            this.readallBox.Name = "readallBox";
            this.readallBox.Size = new System.Drawing.Size(108, 20);
            this.readallBox.TabIndex = 17;
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.label1);
            this.groupBox1.Controls.Add(this.comportNumberbox);
            this.groupBox1.Controls.Add(this.openportButton);
            this.groupBox1.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.groupBox1.Location = new System.Drawing.Point(12, 12);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(251, 57);
            this.groupBox1.TabIndex = 28;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "COM Port";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.Location = new System.Drawing.Point(142, 10);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(87, 13);
            this.label2.TabIndex = 5;
            this.label2.Text = "Firmware Version";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.Location = new System.Drawing.Point(122, 16);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(121, 13);
            this.label1.TabIndex = 4;
            this.label1.Text = "Enter COM Port Number";
            // 
            // verButton
            // 
            this.verButton.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.verButton.Location = new System.Drawing.Point(7, 14);
            this.verButton.Name = "verButton";
            this.verButton.Size = new System.Drawing.Size(113, 33);
            this.verButton.TabIndex = 3;
            this.verButton.Text = "version";
            this.verButton.UseVisualStyleBackColor = true;
            this.verButton.Click += new System.EventHandler(this.verButton_Click);
            // 
            // verBox
            // 
            this.verBox.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.verBox.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.verBox.Location = new System.Drawing.Point(126, 23);
            this.verBox.Multiline = true;
            this.verBox.Name = "verBox";
            this.verBox.Size = new System.Drawing.Size(116, 22);
            this.verBox.TabIndex = 2;
            // 
            // comportNumberbox
            // 
            this.comportNumberbox.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.comportNumberbox.Location = new System.Drawing.Point(125, 29);
            this.comportNumberbox.Multiline = true;
            this.comportNumberbox.Name = "comportNumberbox";
            this.comportNumberbox.Size = new System.Drawing.Size(116, 22);
            this.comportNumberbox.TabIndex = 1;
            // 
            // openportButton
            // 
            this.openportButton.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.openportButton.Location = new System.Drawing.Point(6, 16);
            this.openportButton.Name = "openportButton";
            this.openportButton.Size = new System.Drawing.Size(113, 36);
            this.openportButton.TabIndex = 0;
            this.openportButton.Text = "Open COM Port";
            this.openportButton.UseVisualStyleBackColor = true;
            this.openportButton.Click += new System.EventHandler(this.openportButton_Click);
            // 
            // groupBox3
            // 
            this.groupBox3.Controls.Add(this.label4);
            this.groupBox3.Controls.Add(this.label3);
            this.groupBox3.Controls.Add(this.adcstatusBox);
            this.groupBox3.Controls.Add(this.adcNumberBox);
            this.groupBox3.Controls.Add(this.adcButton);
            this.groupBox3.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.groupBox3.Location = new System.Drawing.Point(10, 238);
            this.groupBox3.Name = "groupBox3";
            this.groupBox3.Size = new System.Drawing.Size(251, 105);
            this.groupBox3.TabIndex = 30;
            this.groupBox3.TabStop = false;
            this.groupBox3.Text = "ADC";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label4.Location = new System.Drawing.Point(150, 59);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(59, 13);
            this.label4.TabIndex = 14;
            this.label4.Text = "ADC Value";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.Location = new System.Drawing.Point(121, 18);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(122, 13);
            this.label3.TabIndex = 13;
            this.label3.Text = "Analog Channel Number";
            // 
            // adcstatusBox
            // 
            this.adcstatusBox.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.adcstatusBox.Location = new System.Drawing.Point(124, 73);
            this.adcstatusBox.Multiline = true;
            this.adcstatusBox.Name = "adcstatusBox";
            this.adcstatusBox.Size = new System.Drawing.Size(118, 22);
            this.adcstatusBox.TabIndex = 12;
            // 
            // adcNumberBox
            // 
            this.adcNumberBox.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.adcNumberBox.Location = new System.Drawing.Point(124, 34);
            this.adcNumberBox.Multiline = true;
            this.adcNumberBox.Name = "adcNumberBox";
            this.adcNumberBox.Size = new System.Drawing.Size(118, 22);
            this.adcNumberBox.TabIndex = 11;
            // 
            // adcButton
            // 
            this.adcButton.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.adcButton.Location = new System.Drawing.Point(6, 18);
            this.adcButton.Name = "adcButton";
            this.adcButton.Size = new System.Drawing.Size(113, 78);
            this.adcButton.TabIndex = 10;
            this.adcButton.Text = "ADC";
            this.adcButton.UseVisualStyleBackColor = true;
            this.adcButton.Click += new System.EventHandler(this.adcButton_Click);
            // 
            // groupBox4
            // 
            this.groupBox4.Controls.Add(this.readallBox);
            this.groupBox4.Controls.Add(this.writeallBox);
            this.groupBox4.Controls.Add(this.dirBox);
            this.groupBox4.Controls.Add(this.maskBox);
            this.groupBox4.Controls.Add(this.readallButton);
            this.groupBox4.Controls.Add(this.writeallButton);
            this.groupBox4.Controls.Add(this.iodirButton);
            this.groupBox4.Controls.Add(this.iomaskButton);
            this.groupBox4.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.groupBox4.Location = new System.Drawing.Point(268, 216);
            this.groupBox4.Name = "groupBox4";
            this.groupBox4.Size = new System.Drawing.Size(252, 127);
            this.groupBox4.TabIndex = 31;
            this.groupBox4.TabStop = false;
            this.groupBox4.Text = "IOmask / IOdir / Writeall / Readall";
            // 
            // writeallBox
            // 
            this.writeallBox.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.writeallBox.Location = new System.Drawing.Point(126, 71);
            this.writeallBox.Name = "writeallBox";
            this.writeallBox.Size = new System.Drawing.Size(108, 20);
            this.writeallBox.TabIndex = 17;
            // 
            // dirBox
            // 
            this.dirBox.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.dirBox.Location = new System.Drawing.Point(126, 45);
            this.dirBox.Name = "dirBox";
            this.dirBox.Size = new System.Drawing.Size(108, 20);
            this.dirBox.TabIndex = 17;
            // 
            // maskBox
            // 
            this.maskBox.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.maskBox.Location = new System.Drawing.Point(126, 20);
            this.maskBox.Name = "maskBox";
            this.maskBox.Size = new System.Drawing.Size(108, 20);
            this.maskBox.TabIndex = 17;
            // 
            // readallButton
            // 
            this.readallButton.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.readallButton.Location = new System.Drawing.Point(16, 95);
            this.readallButton.Name = "readallButton";
            this.readallButton.Size = new System.Drawing.Size(104, 23);
            this.readallButton.TabIndex = 16;
            this.readallButton.Text = "readall";
            this.readallButton.UseVisualStyleBackColor = true;
            this.readallButton.Click += new System.EventHandler(this.readallButton_Click);
            // 
            // writeallButton
            // 
            this.writeallButton.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.writeallButton.Location = new System.Drawing.Point(16, 70);
            this.writeallButton.Name = "writeallButton";
            this.writeallButton.Size = new System.Drawing.Size(104, 23);
            this.writeallButton.TabIndex = 15;
            this.writeallButton.Text = "writeall";
            this.writeallButton.UseVisualStyleBackColor = true;
            this.writeallButton.Click += new System.EventHandler(this.writeallButton_Click);
            // 
            // iodirButton
            // 
            this.iodirButton.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.iodirButton.Location = new System.Drawing.Point(16, 44);
            this.iodirButton.Name = "iodirButton";
            this.iodirButton.Size = new System.Drawing.Size(104, 23);
            this.iodirButton.TabIndex = 14;
            this.iodirButton.Text = "iodir";
            this.iodirButton.UseVisualStyleBackColor = true;
            this.iodirButton.Click += new System.EventHandler(this.iodirButton_Click);
            // 
            // iomaskButton
            // 
            this.iomaskButton.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.iomaskButton.Location = new System.Drawing.Point(16, 19);
            this.iomaskButton.Name = "iomaskButton";
            this.iomaskButton.Size = new System.Drawing.Size(104, 23);
            this.iomaskButton.TabIndex = 13;
            this.iomaskButton.Text = "iomask";
            this.iomaskButton.UseVisualStyleBackColor = true;
            this.iomaskButton.Click += new System.EventHandler(this.iomaskButton_Click);
            // 
            // idnumberBox
            // 
            this.idnumberBox.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.idnumberBox.Location = new System.Drawing.Point(124, 21);
            this.idnumberBox.Multiline = true;
            this.idnumberBox.Name = "idnumberBox";
            this.idnumberBox.Size = new System.Drawing.Size(117, 30);
            this.idnumberBox.TabIndex = 7;
            // 
            // idsetButton
            // 
            this.idsetButton.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.idsetButton.Location = new System.Drawing.Point(6, 19);
            this.idsetButton.Name = "idsetButton";
            this.idsetButton.Size = new System.Drawing.Size(113, 34);
            this.idsetButton.TabIndex = 6;
            this.idsetButton.Text = "id set";
            this.idsetButton.UseVisualStyleBackColor = true;
            this.idsetButton.Click += new System.EventHandler(this.idsetButton_Click);
            // 
            // idgetBox
            // 
            this.idgetBox.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.idgetBox.Location = new System.Drawing.Point(124, 61);
            this.idgetBox.Multiline = true;
            this.idgetBox.Name = "idgetBox";
            this.idgetBox.Size = new System.Drawing.Size(117, 30);
            this.idgetBox.TabIndex = 5;
            // 
            // idgetButton
            // 
            this.idgetButton.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.idgetButton.Location = new System.Drawing.Point(6, 59);
            this.idgetButton.Name = "idgetButton";
            this.idgetButton.Size = new System.Drawing.Size(113, 34);
            this.idgetButton.TabIndex = 4;
            this.idgetButton.Text = "id get";
            this.idgetButton.UseVisualStyleBackColor = true;
            this.idgetButton.Click += new System.EventHandler(this.idgetButton_Click);
            // 
            // groupBox2
            // 
            this.groupBox2.Controls.Add(this.idnumberBox);
            this.groupBox2.Controls.Add(this.idsetButton);
            this.groupBox2.Controls.Add(this.idgetBox);
            this.groupBox2.Controls.Add(this.idgetButton);
            this.groupBox2.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.groupBox2.Location = new System.Drawing.Point(10, 131);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Size = new System.Drawing.Size(251, 101);
            this.groupBox2.TabIndex = 29;
            this.groupBox2.TabStop = false;
            this.groupBox2.Text = "ID";
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label6.Location = new System.Drawing.Point(136, 48);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(69, 13);
            this.label6.TabIndex = 10;
            this.label6.Text = " GPIO Status";
            // 
            // groupBox5
            // 
            this.groupBox5.Controls.Add(this.groupBox7);
            this.groupBox5.Controls.Add(this.groupBox6);
            this.groupBox5.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.groupBox5.Location = new System.Drawing.Point(269, 12);
            this.groupBox5.Name = "groupBox5";
            this.groupBox5.Size = new System.Drawing.Size(251, 202);
            this.groupBox5.TabIndex = 32;
            this.groupBox5.TabStop = false;
            this.groupBox5.Text = "GPIO";
            // 
            // groupBox7
            // 
            this.groupBox7.Controls.Add(this.label7);
            this.groupBox7.Controls.Add(this.label8);
            this.groupBox7.Controls.Add(this.gpiostatusShowBox);
            this.groupBox7.Controls.Add(this.gpioNumberReadBox);
            this.groupBox7.Controls.Add(this.gpioreadButton);
            this.groupBox7.Location = new System.Drawing.Point(7, 103);
            this.groupBox7.Name = "groupBox7";
            this.groupBox7.Size = new System.Drawing.Size(236, 90);
            this.groupBox7.TabIndex = 14;
            this.groupBox7.TabStop = false;
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label7.Location = new System.Drawing.Point(133, 47);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(69, 13);
            this.label7.TabIndex = 12;
            this.label7.Text = " GPIO Status";
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label8.Location = new System.Drawing.Point(133, 10);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(76, 13);
            this.label8.TabIndex = 13;
            this.label8.Text = " GPIO Number";
            // 
            // gpiostatusShowBox
            // 
            this.gpiostatusShowBox.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.gpiostatusShowBox.Location = new System.Drawing.Point(117, 60);
            this.gpiostatusShowBox.Multiline = true;
            this.gpiostatusShowBox.Name = "gpiostatusShowBox";
            this.gpiostatusShowBox.Size = new System.Drawing.Size(108, 22);
            this.gpiostatusShowBox.TabIndex = 9;
            // 
            // gpioNumberReadBox
            // 
            this.gpioNumberReadBox.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.gpioNumberReadBox.Location = new System.Drawing.Point(117, 24);
            this.gpioNumberReadBox.Multiline = true;
            this.gpioNumberReadBox.Name = "gpioNumberReadBox";
            this.gpioNumberReadBox.Size = new System.Drawing.Size(108, 22);
            this.gpioNumberReadBox.TabIndex = 9;
            // 
            // gpioreadButton
            // 
            this.gpioreadButton.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.gpioreadButton.Location = new System.Drawing.Point(8, 13);
            this.gpioreadButton.Name = "gpioreadButton";
            this.gpioreadButton.Size = new System.Drawing.Size(104, 69);
            this.gpioreadButton.TabIndex = 8;
            this.gpioreadButton.Text = "read";
            this.gpioreadButton.UseVisualStyleBackColor = true;
            this.gpioreadButton.Click += new System.EventHandler(this.gpioreadButton_Click);
            // 
            // groupBox6
            // 
            this.groupBox6.Controls.Add(this.label6);
            this.groupBox6.Controls.Add(this.label5);
            this.groupBox6.Controls.Add(this.setStatusBox);
            this.groupBox6.Controls.Add(this.gpioNumberBox);
            this.groupBox6.Controls.Add(this.gpiosetButton);
            this.groupBox6.Location = new System.Drawing.Point(8, 11);
            this.groupBox6.Name = "groupBox6";
            this.groupBox6.Size = new System.Drawing.Size(235, 91);
            this.groupBox6.TabIndex = 11;
            this.groupBox6.TabStop = false;
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label5.Location = new System.Drawing.Point(133, 11);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(76, 13);
            this.label5.TabIndex = 10;
            this.label5.Text = " GPIO Number";
            // 
            // setStatusBox
            // 
            this.setStatusBox.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.setStatusBox.Location = new System.Drawing.Point(117, 61);
            this.setStatusBox.Multiline = true;
            this.setStatusBox.Name = "setStatusBox";
            this.setStatusBox.Size = new System.Drawing.Size(108, 22);
            this.setStatusBox.TabIndex = 9;
            // 
            // gpioNumberBox
            // 
            this.gpioNumberBox.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.gpioNumberBox.Location = new System.Drawing.Point(117, 24);
            this.gpioNumberBox.Multiline = true;
            this.gpioNumberBox.Name = "gpioNumberBox";
            this.gpioNumberBox.Size = new System.Drawing.Size(108, 22);
            this.gpioNumberBox.TabIndex = 9;
            // 
            // groupBox8
            // 
            this.groupBox8.Controls.Add(this.label2);
            this.groupBox8.Controls.Add(this.verButton);
            this.groupBox8.Controls.Add(this.verBox);
            this.groupBox8.Location = new System.Drawing.Point(11, 71);
            this.groupBox8.Name = "groupBox8";
            this.groupBox8.Size = new System.Drawing.Size(251, 55);
            this.groupBox8.TabIndex = 33;
            this.groupBox8.TabStop = false;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.SystemColors.ControlDark;
            this.ClientSize = new System.Drawing.Size(531, 353);
            this.Controls.Add(this.groupBox8);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.groupBox3);
            this.Controls.Add(this.groupBox4);
            this.Controls.Add(this.groupBox2);
            this.Controls.Add(this.groupBox5);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MaximizeBox = false;
            this.MaximumSize = new System.Drawing.Size(547, 391);
            this.MinimumSize = new System.Drawing.Size(547, 391);
            this.Name = "Form1";
            this.Text = "32 Channel Usb Gpio Module Demo";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.groupBox3.ResumeLayout(false);
            this.groupBox3.PerformLayout();
            this.groupBox4.ResumeLayout(false);
            this.groupBox4.PerformLayout();
            this.groupBox2.ResumeLayout(false);
            this.groupBox2.PerformLayout();
            this.groupBox5.ResumeLayout(false);
            this.groupBox7.ResumeLayout(false);
            this.groupBox7.PerformLayout();
            this.groupBox6.ResumeLayout(false);
            this.groupBox6.PerformLayout();
            this.groupBox8.ResumeLayout(false);
            this.groupBox8.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button gpiosetButton;
        private System.Windows.Forms.TextBox readallBox;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button verButton;
        private System.Windows.Forms.TextBox verBox;
        private System.Windows.Forms.TextBox comportNumberbox;
        private System.Windows.Forms.Button openportButton;
        private System.Windows.Forms.GroupBox groupBox3;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox adcstatusBox;
        private System.Windows.Forms.TextBox adcNumberBox;
        private System.Windows.Forms.Button adcButton;
        private System.Windows.Forms.GroupBox groupBox4;
        private System.Windows.Forms.TextBox writeallBox;
        private System.Windows.Forms.TextBox dirBox;
        private System.Windows.Forms.TextBox maskBox;
        private System.Windows.Forms.Button readallButton;
        private System.Windows.Forms.Button writeallButton;
        private System.Windows.Forms.Button iodirButton;
        private System.Windows.Forms.Button iomaskButton;
        private System.Windows.Forms.TextBox idnumberBox;
        private System.Windows.Forms.Button idsetButton;
        private System.Windows.Forms.TextBox idgetBox;
        private System.Windows.Forms.Button idgetButton;
        private System.IO.Ports.SerialPort serialPort1;
        private System.Windows.Forms.GroupBox groupBox2;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.GroupBox groupBox5;
        private System.Windows.Forms.GroupBox groupBox7;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.TextBox gpiostatusShowBox;
        private System.Windows.Forms.TextBox gpioNumberReadBox;
        private System.Windows.Forms.Button gpioreadButton;
        private System.Windows.Forms.GroupBox groupBox6;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.TextBox setStatusBox;
        private System.Windows.Forms.TextBox gpioNumberBox;
        private System.Windows.Forms.GroupBox groupBox8;
    }
}

