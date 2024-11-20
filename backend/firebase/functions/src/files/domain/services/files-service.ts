import { CleanFilesFeature, CleanResult } from "../ports/in/clean-files-feature";
import { FilesRepository } from "../ports/out/files-repository";

export class FilesService implements CleanFilesFeature {
    constructor(private readonly filesRepository: FilesRepository) { }

    async cleanExpiredFiles(): Promise<CleanResult> {
        const result: CleanResult = {
            deletedFiles: [],
            errors: [],
            totalCleaned: 0
        };

        try {
            const expiredFiles = await this.filesRepository.findExpiredFiles();

            for (const file of expiredFiles) {
                try {
                    await this.filesRepository.deleteFile(file.uid);
                    result.deletedFiles.push(file.uid);
                    result.totalCleaned++;
                } catch (error) {
                    result.errors.push(`Failed to delete ${file.path}: ${error}`);
                }
            }
        } catch (error) {
            throw new Error(`Error cleaning files: ${error}`);
        }

        return result;
    }
}