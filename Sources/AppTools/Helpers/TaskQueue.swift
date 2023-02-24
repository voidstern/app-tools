//
//  TaskQueue.swift
//  Tidur Timers
//
//  Created by Lukas Burgstaller on 09.02.23.
//  Copyright © 2023 Lukas Burgstaller. All rights reserved.
//

import Foundation

class TaskQueue {
    private actor TaskQueueActor {
        private var blocks : [() async -> Void] = []
        private var currentTask : Task<Void,Never>? = nil
        
        func addBlock(block:@escaping () async -> Void){
            blocks.append(block)
            next()
        }
        
        func next()
        {
            if(currentTask != nil) {
                return
            }
            if(!blocks.isEmpty)
            {
                let block = blocks.removeFirst()
                currentTask = Task{
                    await block()
                    currentTask = nil
                    next()
                }
            }
        }
    }
    
    private let taskQueueActor = TaskQueueActor()
    
    func dispatch(block: @escaping () async ->Void){
        Task{
            await taskQueueActor.addBlock(block: block)
        }
    }
}
