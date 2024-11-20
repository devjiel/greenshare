
import { CleanupOrchestratorService } from '../domain/services/cleanup-orchestrator-service';
import { FilesService } from '../../files/domain/services/files-service';
import { UsersService } from '../../users/domain/services/users-service';
import { FirebaseFilesRepository } from '../../files/infrastructure/persistence/firebase-files-repository';
import { FirebaseUsersRepository } from '../../users/infrastructure/persistence/firebase-users-repository';
import { CleanResult } from '../domain/ports/in/cleanup-orchestrator-feature';

export class FileCleanerController {
    async clean(): Promise<CleanResult> {

        const filesRepository = new FirebaseFilesRepository();
        const filesService = new FilesService(filesRepository);

        const usersRepository = new FirebaseUsersRepository();
        const usersService = new UsersService(usersRepository);

        const orchestrator = new CleanupOrchestratorService(filesService, usersService);
        let response = await orchestrator.cleanupExpiredFiles();

        return response;
    }
}