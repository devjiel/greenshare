import { CleanFilesFeature, CleanResult } from "../../../files/domain/ports/in/clean-files-feature";
import { CleanUserFilesFeature } from "../../../users/domain/ports/in/clean-user-files-feature";
import { CleanupOrchestratorFeature } from "../ports/in/cleanup-orchestrator-feature";
import * as logger from "firebase-functions/logger";

export class CleanupOrchestratorService implements CleanupOrchestratorFeature {
    constructor(
        private readonly filesService: CleanFilesFeature,
        private readonly usersService: CleanUserFilesFeature
    ) { }

    async cleanupExpiredFiles(): Promise<CleanResult> {
        const filesResult = await this.filesService.cleanExpiredFiles();

        for (const fileUid of Object.keys(filesResult.fileLinkWithUser)) {
            try {
                const userResult = await this.usersService.removeFileReferences(
                    filesResult.fileLinkWithUser[fileUid],
                    fileUid
                );

                logger.info(`Updated users for file ${fileUid}`, userResult);
            } catch (error) {
                logger.error(`Failed to clean user references for ${fileUid}`, error);
            }
        }

        return {
            deletedFiles: filesResult.deletedFiles,
            errors: filesResult.errors,
            totalCleaned: filesResult.totalCleaned
        } as CleanResult;
    }
}