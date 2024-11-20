import { CleanFilesFeature, CleanResult } from "../../../files/domain/ports/in/clean-files-feature";
import { CleanUserFilesFeature } from "../../../users/domain/ports/in/clean-user-files-feature";
import * as logger from "firebase-functions/logger";

export class CleanupOrchestratorService {
    constructor(
        private readonly filesService: CleanFilesFeature,
        private readonly usersService: CleanUserFilesFeature
    ) { }

    async cleanupExpiredFiles(): Promise<CleanResult> {
        const filesResult = await this.filesService.cleanExpiredFiles();

        for (const fileUid of filesResult.deletedFiles) {
            try {
                const userResult = await this.usersService.removeFileReferences(fileUid);
                logger.info(`Updated users for file ${fileUid}`, userResult);
            } catch (error) {
                logger.error(`Failed to clean user references for ${fileUid}`, error);
            }
        }

        return filesResult;
    }
}