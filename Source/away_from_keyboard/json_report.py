import json
import datetime
import math
import os.path
import pprint
import os
from tabulate import tabulate

class Report:
    def __init__(self):
        #Config
        folder_name = "Reports"

        #Main dictionary for report
        self.report_dic = {}

        self.today = datetime.datetime.now()
        #self.report_update_week()
        self.week = self.today.isocalendar()[1]

        
        self.json_rep_file_path = "W" + str(self.week) + "_Report.json"
        self.json_rep_file_path = os.path.join(folder_name, self.json_rep_file_path)
        self.md_rep_file_path = "W" + str(self.week) + "_Report.md"
        self.md_rep_file_path = os.path.join(folder_name, self.md_rep_file_path)

        #Create a directory for reports
        if(os.path.isdir(folder_name) == False):
            os.mkdir(folder_name)


        #Load actual json report
        if os.path.isfile(self.json_rep_file_path):
            print(f"JSON Report {self.json_rep_file_path}")
            with open(self.json_rep_file_path, "r") as json_file:
                #TODO Validate the document, is empty, is a valid JSON report ???
                self.report_dic = json.loads(json_file.read())
        #Or create a new dictionary for reporting
        else:
            self.report_dic["week_number"] = self.week
            self.report_dic["worked_time_hr"] = 0
            self.report_dic["worked_time_min"] = 0
            self.report_dic["issues"] = []
            # Avoid the need of creating and dummy day
            self.report_dic["days"] = [{"name":"None", "time":"00:00:00"}]

            #Set the fixed information
            self.set_today()

    def set_today(self):        
        day = {}
        day["date"] = self.today.strftime("%m/%d/%y")
        day["name"] = self.today.strftime("%A")

        day_idx = self.day_get_idx(day["name"])
        #If item don't exist add the item
        if day_idx == None:
            self.report_dic["days"].append(day)

    def today_update_time(self, time):
        #Get the actual day
        day_idx = self.day_get_idx(self.today.strftime("%A"))
        #Check if the day exist
        if day_idx != None:
            self.report_dic["days"][day_idx]["time"] = time

    def today_get_time(self):
        today_time = datetime.time()
        # Get today index
        day_name = self.today.strftime("%A")
        day_idx = self.day_get_idx(day_name)

        #If item exist add the item
        if day_idx != None:

            #Try to get time parts
            try:
                time_parts = self.report_dic["days"][day_idx]["time"].split(":")
                #Format timer object
                today_time = datetime.time(int(time_parts[0]), int(time_parts[1]), int(time_parts[2]))
            except:
                today_time = datetime.time(0,0,0)

        else:
            today_time = datetime.time(0,0,0)

        print(f"Today time get {today_time}, Index {day_idx}, Day name {day_name}")

        return today_time


    def report_add_issue(self, name, project, time, start_time):
        issue = {}
        issue["name"] = name
        issue["project"] = project
        issue["tasks"] = []
        issue["time"] = time
        issue["start_time"] = start_time

        #Get the issue location
        issue_ind = self.issue_get_idx(name)
        #Look if the issue doesn't exist
        if issue_ind == None:
            self.report_dic["issues"].append(issue)

    def report_set_issue(self, name, new_name, project, timer):
        
        activity_ind = self.issue_get_idx(name)

        if activity_ind != None:
            self.report_dic["issues"][activity_ind]["name"] = new_name
            self.report_dic["issues"][activity_ind]["project"] = project
            self.report_dic["issues"][activity_ind]["time"] = timer.strftime("%H:%M:%S")



    def report_add_item(self, time, log, date, activity_name):
        item = {}
        item["time"] = time
        item["log"] = log
        item["date"] = date

        activity_ind = self.issue_get_idx(activity_name)

        #If activity exist
        if activity_ind != None:

            item_idx = self.task_get_idx(activity_ind, log)
            #If item don't exist add the item
            if item_idx == None:
                self.report_dic["issues"][activity_ind]["tasks"].append(item)
            else: #Update the item
                self.report_dic["issues"][activity_ind]["tasks"][item_idx] = item

    def report_update_task(self,issue, name, time):
        
        activity_ind = self.issue_get_idx(issue)
        #If activity exist
        if activity_ind != None:
            item_idx = self.task_get_idx(activity_ind, log)
            #If item exist add the item
            if item_idx != None:
                self.report_dic["issues"][activity_ind]["tasks"][item_idx]["time"] = time
                self.report_dic["issues"][activity_ind]["tasks"][item_idx]["name"] = name
                self.report_dic["issues"][activity_ind]["tasks"][item_idx]["last_update"] = self.today.strftime('%m/%d/%y %H:%M:%S')



    def add_task(self, issue, name):
        task = {}
        task['time'] = '00:00:00'
        task['name'] = name
        task['last_update'] = '00:00:00'
        task['creation_date'] = self.today.strftime('%m/%d/%y %H:%M:%S')
        # Get the index for the issue
        issue_idx = self.issue_get_idx(issue)
        # Check if the task is not already logged
        if(issue_idx != None):
            task_idx = self.task_get_idx(issue_idx, name)
            # If the task haven't been logged, the add the task to the issue
            if task_idx == None:
                self.report_dic["issues"][issue_idx]["tasks"].append(task)


    def report_set_issue(self, name, new_name, project, timer):
        
        activity_ind = self.issue_get_idx(name)

        if activity_ind != None:
            self.report_dic["issues"][activity_ind]["name"] = new_name
            self.report_dic["issues"][activity_ind]["project"] = project
            self.report_dic["issues"][activity_ind]["time"] = timer.strftime("%H:%M:%S")


    def issue_get_idx(self, issue_name):


        incidence = False
        activity_ind = 0

        for activity in self.report_dic["issues"]:
            if activity["name"] == issue_name:
                incidence = True
                break

            activity_ind = activity_ind + 1

        if incidence == False:
            activity_ind = None 

        return activity_ind

    def get_issue(self, issue_name):

        if "issues" in self.report_dic:
            for issue in self.report_dic["issues"]:
                if issue["name"] == issue_name:
                    return issue
        else:
            return None


    def issue_get_project(self, issue_name):

        issue_idx = self.issue_get_idx(issue_name)

        # If issue exist
        if issue_idx != None:
            project = self.report_dic["issues"][issue_idx]["project"]
        else:
            project = None

        return project

    def day_get_idx(self, day_name):

        incidence = False
        day_idx = 0

        for day in self.report_dic["days"]:
            try: 
                if day["name"] == day_name:
                    incidence = True
                    break

                day_idx = day_idx + 1

            except:
                day_idx = None

        if incidence == False:
            day_idx = None 

        return day_idx


    def task_get_idx(self, activity_idx, item_log):

        item_idx = 0
        incidence = False

        for item in self.report_dic["issues"][activity_idx]["tasks"]:
            if item["name"] == item_log:
                incidence = True
                break

            item_idx = item_idx + 1

        if incidence == False:
            item_idx = None


        return item_idx


    def issue_task_get_idx(self, issue_name, task):

        item_idx = 0
        incidence = False

        issue_idx = self.issue_get_idx(issue_name)

        for item in self.report_dic["issues"][issue_idx]["tasks"]:
            if item["log"] == task:
                incidence = True
                break

            item_idx = item_idx + 1

        if incidence == False:
            item_idx = None


        return item_idx


    def report_print_json(self):

        with open(self.json_rep_file_path, "w") as file_object:
            file_object.write(json.dumps(self.report_dic, indent=4, sort_keys=True))

    def report_update_week(self):
        self.week = self.today.isocalendar()[1]
        #self.report_dic["week_number"] = self.week


    def report_update_worked_time(self):

        total_week_time_seconds = 0
        total_activity_time_seconds = 0

        for activity in self.report_dic["issues"]:
            for item in activity["tasks"]:
                time_seconds = self.time_str2int_seconds(item["time"])
                #Total week time in seconds
                total_week_time_seconds = total_week_time_seconds + time_seconds
                #Total activity time in seconds
                total_activity_time_seconds = total_activity_time_seconds + time_seconds

            #Report activity total time and then reset it
            activity_time_hours, activity_time_minutes = self.report_sec_to_hr_min(total_activity_time_seconds)

            activity["total_time_hr"] = activity_time_hours
            activity["total_time_min"] = activity_time_minutes


            total_activity_time_seconds = 0

        #Report week time
        week_time_hours = math.trunc(total_week_time_seconds / 3600)
        week_time_minutes = math.trunc((total_week_time_seconds % 3600) / 60)

        self.report_dic["worked_time_hr"] = week_time_hours
        self.report_dic["worked_time_min"] = week_time_minutes

    def week_update_worked_time(self):

        total_week_time_seconds = 0

        # Add the time for all the week days
        for day in self.report_dic["days"]:
            day_time_seconds = self.time_str2int_seconds(day["time"])
            total_week_time_seconds = total_week_time_seconds + day_time_seconds

        # Convert total time to hrs and minutes
        hours = math.trunc(total_week_time_seconds / 3600)
        
        if hours >= 24:
            hours = 23

        minutes = math.trunc((total_week_time_seconds % 3600) / 60)

        #Add to report dictionary
        self.report_dic["worked_time"] = datetime.time(hours,minutes,0).strftime("%H:%M:%S")
        self.report_dic["worked_time_hr"] = hours
        self.report_dic["worked_time_min"] = minutes


    def time_str2int_seconds(self, counter):
        time_parts = counter.split(":")
        time_seconds = (int(time_parts[0]) * 3600) + (int(time_parts[1]) * 60) + int(time_parts[2])

        return time_seconds
    
    def report_sec_to_hr_min(self, seconds):
        hours = math.trunc(seconds / 3600)
        minutes = math.trunc((seconds % 3600) / 60)

        return hours, minutes

    def report_get_task_time(self, issue_name, task):

        task_time = datetime.time()
        
        activity_idx = self.issue_get_idx(issue_name)

        if activity_idx != None:
            task_idx = self.task_get_idx(activity_idx, task)

            if task_idx != None:
                act_time_split =  self.report_dic["issues"][activity_idx]["tasks"][task_idx]["time"].split(":")
                task_time = datetime.time(int(act_time_split[0]), int(act_time_split[1]), int(act_time_split[2]))
            else:
                task_time = datetime.time(0, 0, 0)
        else:
            task_time = datetime.time(0, 0, 0)

        return task_time
            

    def report_get_issue_time(self, issue_name):

        issue_time = datetime.time()
        
        activity_idx = self.issue_get_idx(issue_name)

        if activity_idx != None:
            act_time_split =  self.report_dic["issues"][activity_idx]["time"].split(":")
            issue_time = datetime.time(int(act_time_split[0]), int(act_time_split[1]), int(act_time_split[2]))

        else:
            issue_time = datetime.time(0, 0, 0)

        return issue_time

    def json_report_open(self):
        os.system(f"code {self.json_rep_file_path}")


    def issue_get_all_names(self):
        issues_array = []

        if "issues" in self.report_dic:
            for issue in self.report_dic["issues"]:
                issues_array.append(issue["name"])
            return issues_array
        else:
            return None


    def project_get_all(self):
        projects_array = []
        for project in self.report_dic["issues"]:
            projects_array.append(project["project"])

        return projects_array

    def task_get_all(self, issue):
        tasks_array = []

        issue_idx = self.issue_get_idx(issue)

        for task in self.report_dic["issues"][issue_idx]["tasks"]:
            tasks_array.append(task["log"])

        return tasks_array

    def task_get_all_names(self, issue):
        tasks_array = []

        issue_from_dict = self.get_issue(issue)

        if issue_from_dict != None:
            if "tasks" in issue_from_dict:
                for task in issue_from_dict["tasks"]:
                    tasks_array.append(task["log"])
                return tasks_array

        return None    

    def generate_report(self):
        #Update the information before printing
        #self.report_update_worked_time()
        #Get activity logs and time
        rows = []
        txt_dictionary = {}
        #Add firs row as header
        txt_dictionary["project"] = "Project"
        txt_dictionary["name"] = "Activity"
        txt_dictionary["time"] = "Time"
        txt_dictionary["logs"] = "Logs"

        rows.append(txt_dictionary)

        for idx, activity in enumerate(self.report_dic["issues"]):
            logs = ""
            for item in activity["tasks"]:
                logs = logs + item["log"] + ", " 

            #Rounded time to report just hours
            #if activity["total_time_min"] > 30:
            #    activity["total_time_hr"] = activity["total_time_hr"]  + 1
            #Make time a fraction
            #time = float(activity["worked_time_hr"]) + float(activity["worked_time_min"])  / 60
            
            #Save the activity info in a row for a file
            txt_dictionary = {}
            txt_dictionary["project"] = activity["project"]
            txt_dictionary["name"] = activity["name"]
            txt_dictionary["time"] = activity["time"]
            txt_dictionary["logs"] = logs
            
            rows.append(txt_dictionary)

        header = ["Activity name", "Time (hr)", "Logs"]
        
        with open(self.md_rep_file_path, "w") as md_file:
            md_file.write(f"# WEEK {self.report_dic['week_number']} REPORT\n")
            md_file.write( tabulate( rows, headers="firstrow", tablefmt = "github" , numalign="left")   )
            #End MD file with and empty line
            md_file.write(f"\n")

        os.system(f"code {self.md_rep_file_path}")
