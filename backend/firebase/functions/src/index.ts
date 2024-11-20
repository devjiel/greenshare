// import { onSchedule } from "firebase-functions/v2/scheduler";
import { onRequest } from "firebase-functions/https";
import * as logger from "firebase-functions/logger";
import { FileCleanerController } from "./files-cleaner/exposition/files_cleaner_controller";
import * as admin from "firebase-admin";
import { CleanResult } from "./files/domain/ports/in/clean-files-feature";

/*export const cleanExpiredFiles = onSchedule("every 24 hours", async (event) => {
    try {
        logger.info("Starting expired files cleanup");

        const filesRepository = new FirebaseFilesRepository();
        const usersRepository = new FirebaseUsersRepository();
        
        const filesService = new FilesService(filesRepository);
        const usersService = new UsersService(usersRepository);
        
        const orchestrator = new CleanupOrchestratorService(filesService, usersService);
        const result = await orchestrator.cleanupExpiredFiles();

        logger.info("Cleanup completed", result);
        return result;

    } catch (error) {
        logger.error("Error during cleanup", error);
        throw error;
    }
});*/

admin.initializeApp();

export interface FunctionResult {
    deletedFiles: string[];
    errors: string[];
    totalCleaned: number;
}

export const cleanExpiredFiles = onRequest({ cors: true }, async (req, res) => {
    let response: FunctionResult = {
        deletedFiles: [],
        errors: [],
        totalCleaned: 0
    };
    try {
        logger.info("Starting expired files cleanup");

        const controller = new FileCleanerController();
        response = await controller.clean();

        logger.info("Cleanup completed", response);

    } catch (error) {
        logger.error("Error during cleanup", error);
        response.errors.push(`${error}`);
    }

    res.send(response);
});