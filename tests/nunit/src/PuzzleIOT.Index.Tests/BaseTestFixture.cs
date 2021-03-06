﻿using System;
using System.IO;
using NUnit.Framework;
using Newtonsoft.Json.Linq;

namespace NetSwitch.Index.Tests
{
	public class BaseTestFixture
	{
		public string ProjectDirectory;

		public string TemporaryDirectory;
		public string TemporaryProjectDirectory;
		public string TemporaryServicesDirectory;

		public bool AutoDeleteTemporaryDirectory = false;

		public string LinearMqttSettingsFile = "mobile/linearmqtt/newsettings.json";

		public BaseTestFixture()
		{
		}

		[SetUp]
		public void Initialize()
		{
			ProjectDirectory = Path.GetFullPath("../../../..");
			Console.WriteLine("Project directory: ");
			Console.WriteLine(ProjectDirectory);
			Console.WriteLine("");

			TemporaryDirectory = new TemporaryDirectoryCreator().Create(ProjectDirectory);
			Console.WriteLine("Temporary directory: ");
			Console.WriteLine(TemporaryDirectory);
			Console.WriteLine("");

			TemporaryProjectDirectory = Path.Combine(TemporaryDirectory, "project");
			Directory.CreateDirectory(TemporaryProjectDirectory);
			Console.WriteLine("Temporary project directory: ");
			Console.WriteLine(TemporaryProjectDirectory);
			CopyDirectory(ProjectDirectory, TemporaryProjectDirectory);
			Directory.SetCurrentDirectory(TemporaryProjectDirectory);

			if (File.Exists(Path.GetFullPath("is-mock-systemctl.txt")))
			{
				TemporaryServicesDirectory = Path.Combine(TemporaryProjectDirectory, "mock/services");
			}
			else
			{
				TemporaryServicesDirectory = "/lib/systemd/system/";
			}
			Console.WriteLine("Services directory:");
			Console.WriteLine("  " + TemporaryServicesDirectory);

			ClearDevices();
		}

		public void CopyDirectory(string source, string destination)
		{
			var starter = new ProcessStarter();
			starter.Start("rsync -arh --exclude='.git' --exclude='.pioenvs' " + source + "/ " + destination + "/");
			Console.WriteLine(starter.Output);
		}

		[TearDown]
		public void Finish()
		{
			if (AutoDeleteTemporaryDirectory)
				Directory.Delete(TemporaryDirectory, true);
		}

		public void ClearDevices()
		{
			// Clear all devices for the test
			var devicesPath = Path.GetFullPath("devices");
			if (Directory.Exists(devicesPath))
				Directory.Delete(devicesPath, true);
		}

		public DockerProcessStarter GetDockerProcessStarter()
		{
			var starter = new DockerProcessStarter();

			starter.WorkingDirectory = TemporaryProjectDirectory;

			starter.IsMockDocker = File.Exists(Path.GetFullPath("is-mock-docker.txt"));

			return starter;
		}

		public void CheckDeviceInfoWasCreated(string deviceType, string deviceLabel, string deviceName, string devicePort)
		{
			var devicesDir = Path.GetFullPath("devices");
			var deviceDir = Path.Combine(devicesDir, deviceName);

			Console.WriteLine("Device dir:");
			Console.WriteLine(deviceDir);

			var deviceDirExists = Directory.Exists(deviceDir);

			Assert.IsTrue(deviceDirExists, "Device directory not found: " + deviceDir);

			var foundType = File.ReadAllText(Path.Combine(deviceDir, "type.txt")).Trim();

			Assert.AreEqual(deviceType, foundType, "Device type doesn't match.");

			var foundLabel = File.ReadAllText(Path.Combine(deviceDir, "label.txt")).Trim();

			Assert.AreEqual(deviceLabel, foundLabel, "Device label doesn't match.");

			var foundName = File.ReadAllText(Path.Combine(deviceDir, "name.txt")).Trim();

			Assert.AreEqual(deviceName, foundName, "Device name doesn't match.");

			var foundPort = File.ReadAllText(Path.Combine(deviceDir, "port.txt")).Trim();

			Assert.AreEqual(devicePort, foundPort, "Device port doesn't match.");
		}

		public void CheckDevicePinInfoWasCreated(string deviceType, string deviceLabel, string deviceName, int devicePin, string devicePort)
		{
			var devicesDir = Path.GetFullPath("devices");
			var deviceDir = Path.Combine(devicesDir, deviceName);

			Console.WriteLine("Device dir:");
			Console.WriteLine(deviceDir);

			var deviceDirExists = Directory.Exists(deviceDir);

			Assert.IsTrue(deviceDirExists, "Device directory not found: " + deviceDir);

			var foundType = File.ReadAllText(Path.Combine(deviceDir, "type.txt")).Trim();

			Assert.AreEqual(deviceType, foundType, "Device type doesn't match.");

			var foundLabel = File.ReadAllText(Path.Combine(deviceDir, "label.txt")).Trim();

			Assert.AreEqual(deviceLabel, foundLabel, "Device label doesn't match.");

			var foundName = File.ReadAllText(Path.Combine(deviceDir, "name.txt")).Trim();

			Assert.AreEqual(deviceName, foundName, "Device name doesn't match.");

			var foundPin = File.ReadAllText(Path.Combine(deviceDir, "pin.txt")).Trim();

			Assert.AreEqual(devicePin, foundPin, "Device pin doesn't match.");

			var foundPort = File.ReadAllText(Path.Combine(deviceDir, "port.txt")).Trim();

			Assert.AreEqual(devicePort, foundPort, "Device port doesn't match.");
		}

		public void CheckDeviceUIWasCreated(string deviceLabel, string deviceName)
		{
			Console.WriteLine("Checking that the device UI was created...");
			var jsonString = File.ReadAllText(LinearMqttSettingsFile);
			var json = JObject.Parse(jsonString);

			Console.WriteLine(jsonString);

			CheckDeviceElementWasCreated(json, deviceLabel, deviceName, "C");
		}

		public void CheckDevicePinUIWasCreated(string deviceLabel, string deviceName, int devicePin)
		{
			Console.WriteLine("Checking that the device UI was created...");
			var jsonString = File.ReadAllText(LinearMqttSettingsFile);
			var json = JObject.Parse(jsonString);

			Console.WriteLine(jsonString);

			CheckDeviceElementWasCreated(json, deviceLabel, deviceName, "D" + devicePin);
		}

		public void CheckDeviceElementWasCreated(JObject json, string deviceLabel, string deviceName, string topicKey)
		{
			Console.WriteLine("Checking the device summary was created...");
			var dashboardsElement = json["dashboards"];

			var summaryDashboardElement = dashboardsElement[0];

			Console.WriteLine("Summary dashboard element:");
			Console.WriteLine(summaryDashboardElement);

			var summaryDeviceMeterElement = summaryDashboardElement["dashboard"][0];

			Console.WriteLine("Summary dashboard element:");
			Console.WriteLine(summaryDeviceMeterElement);

			Console.WriteLine("Details from json:");
			Console.WriteLine("  name: " + summaryDeviceMeterElement["name"]);
			Console.WriteLine("  topic: " + summaryDeviceMeterElement["topic"]);

			Console.WriteLine("Checking summary device meter name matches device label...");

			Assert.AreEqual(deviceLabel, summaryDeviceMeterElement["name"].ToString(), "Summary element name doesn't match the device label.");

			Console.WriteLine("Checking summary device meter topic matches device name...");

			var expectedTopic = "/" + deviceName + "/" + topicKey;

			Assert.AreEqual(expectedTopic, summaryDeviceMeterElement["topic"].ToString(), "Summary element topic doesn't match the device name.");
		}

		public void CheckDeviceUICount(int numberOfDevicesExpected)
		{
			Console.WriteLine("Checking that the device UI was created...");
			var jsonString = File.ReadAllText(LinearMqttSettingsFile);
			var json = JObject.Parse(jsonString);

			Console.WriteLine("Checking the number of devices is correct...");
			var dashboardsElement = json["dashboards"];

			var expectedCount = 1 + numberOfDevicesExpected;
			var actualCount = ((JArray)dashboardsElement).Count;

			Assert.AreEqual(expectedCount, actualCount, "Wrong number of devices in UI");
		}

		public void CheckMqttBridgeServiceFileWasCreated(string deviceName)
		{
			var serviceFile = Path.Combine(TemporaryServicesDirectory, "puzzleiot-mqtt-bridge-" + deviceName + ".service");

			var fileExists = File.Exists(serviceFile);

			Assert.IsTrue(fileExists, "MQTT bridge service file not created: " + serviceFile);
		}

		public void CheckUpdaterServiceFileWasCreated(string deviceName)
		{
			var serviceFile = Path.Combine(TemporaryServicesDirectory, "puzzleiot-updater-" + deviceName + ".service");

			var fileExists = File.Exists(serviceFile);

			Assert.IsTrue(fileExists, "Updater service file not created: " + serviceFile);
		}
	}
}
