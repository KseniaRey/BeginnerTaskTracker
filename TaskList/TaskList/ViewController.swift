//
//  ViewController.swift
//  TaskList
//
//  Created by Oksana Sardonikova on 10.02.2025.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView! // строка означает, что ты создаешь ссылку на таблицу (интерфейсный элемент), которая будет подключена через IBOutlet и может быть опциональной, но Swift будет ожидать, что она будет инициализирована в какой-то момент.
    /*
     UITableView!: Восклицательный знак в конце типа UITableView! указывает на то, что переменная может быть optional, но она автоматически будет развернута (unwrapped). Это значит, что Swift ожидает, что объект tableView будет обязательно инициализирован в какой-то момент, но на момент объявления он может быть nil. То есть ты можешь работать с этим объектом, но если он окажется nil в какой-то момент, то программа может аварийно завершиться с ошибкой.
     */
    
    // array to hold all the tasks that user had entered that far
    var tasks = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Tasks"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Setup
        
        if !UserDefaults().bool(forKey: "setup"){
            UserDefaults().set(true, forKey: "setup")
            UserDefaults().set(0, forKey: "count")
        }
        
        // Get all current saved tasks
        updateTasks()
    }
    
    func updateTasks(){
        
        tasks.removeAll()
        
        guard let count = UserDefaults().value(forKey: "count") as? Int else{
            // guard — это конструкция в Swift, которая используется для выполнения ранних проверок и выхода из функции, если условие не выполняется.
            return
        }
        for x in 0..<count {
            
            if let task = UserDefaults().value(forKey: "task_\(x + 1)") as? String {
                tasks.append(task)
            }
            
        }
        
        tableView.reloadData()
        
    }

    @IBAction func didTapAdd() {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "entry") as! EntryViewController
        vc.title = "New Task"
        vc.update = {
            DispatchQueue.main.async {
                self.updateTasks()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension ViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) // Вот тут идетнификатор cell потому что в main.storyboard мы дали ей этот идентификатор
        
        cell.textLabel?.text = tasks[indexPath.row]
        /*
         ? (Optional Chaining) — этот вопросительный знак указывает на использование optional chaining. То есть, свойство textLabel может быть nil (например, если по какой-то причине оно не было инициализировано). Если textLabel не nil, то будет выполнено присваивание текста. Если оно равно nil, то ничего не произойдет, и приложение не упадет с ошибкой.
         */
        
        return cell
    }
}
